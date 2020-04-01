%include "../inc/processor-flags.h"

%define SYS_HALT 1
%define SYS_READ 2
%define SYS_ENTER 3

%define CONST_4K_HEX        0x1000
%define PDE_ATRR_S          0x03          ;Atributo del Page Directory Entry - Supervisor
%define PDE_ATRR_U          0x07          ;Atributo del Page Directory Entry - Usuario
%define PTE_ATRR_S_RO       0x01          ;Atributo del Page Table Entry - Supervisor, Read Only
%define PTE_ATRR_S_RW       0x03          ;Atributo del Page Table Entry - Supervisor, Readable/Writable
%define PTE_ATRR_U_RO       0x05          ;Atributo del Page Table Entry - Usuario, Read Only
%define PTE_ATRR_U_RW       0x07          ;Atributo del Page Table Entry - Usuario, Readable/Writable


USE32

GLOBAL IRQ128_Handler

GLOBAL td3_halt
GLOBAL td3_read
GLOBAL td3_enter

EXTERN __fast_memcpy_ram
EXTERN __check_paged

EXTERN DS_SEL_RAM
EXTERN DS_SEL_N3

EXTERN __TABLA_ORIGIN
EXTERN __CANT_ENTER

SECTION .handlers progbits

;Interrupción de System Call - IRQ128 (80h)
;Recibe en eax qué syscall se desea
;Lo recibe de td3_halt o td3_read

IRQ128_Handler:
  sti

  ;Primero verifico qué system call quiere la tarea que llamo a esta IRQ
  cmp eax, SYS_HALT
  je go_halt

  cmp eax, SYS_READ
  je go_read

  cmp eax, SYS_ENTER
  je go_enter

  go_halt:
    call syscall_halt
    jmp exit_irq

  go_read:
    call syscall_read
    jmp exit_irq

  go_enter:
    call syscall_enter

  exit_irq:
    iret

SECTION .systemcall progbits

;SystemCall para haltear
;No recibe
;No devuelve
syscall_halt:

  hlt                               ;Se va a quedar acá hasta que venga una interrupción

  ret

;System Call para leer la tabla de dígitos
;Recibe *buffer     -> zona de memoria de la tarea llamante (user nivel 3)
;Recibe num_bytes   -> tamaño de la zona de memoria
;Se debe copiar la tabla de digitos en la sección Datos
;Al *buffer pasado
;Hay que verificar que *buffer corresponda al espacio de la tarea llamante
;Desde que empieza hasta que termina, dado por num_bytes
;Devuelve 0         -> Hubo algún problema
;Devuele num_bytes  -> Éxito

syscall_read:
  pushad                            ;Pusheo todos los registros por las dudas

  ;Primero verifico si la dirección del buff (comienzo y fin)
  ;esta páginada dentro de la tarea llamante
  ;Lo hago con la función __check_paged

  is_begin_paged:
    push ebp
    mov ebp, esp
    ;Le mando los argumentos necesarios a la función
    push PTE_ATRR_U_RW              ;Atributos de la Table Entry
    push PDE_ATRR_U                 ;Atributos de la Page Directory Entry
    push ebx                        ;Espacio de memoria de la tarea dónde copiar
    mov eax, cr3
    push eax                        ;Árbol de página

    call __check_paged
    leave

    ;Verifico lo que me retornó
    ;Si retornó 0, la dirección de buffer no está paginada para la tarea llamante
    cmp ax, 0x00
    je exit

  ;Si la direccion del comienzo en buffer esta paginada
  ;Me fijo que el final tambien
  ;Dado que recibo la cant de bytes a copiar
  ;Puedo saber hasta el final

  is_end_paged:
    push ebp
    mov ebp, esp
    ;Le mando los argumentos necesarios a la función
    push PTE_ATRR_U_RW              ;Atributos de la Page Directory Entry
    push PDE_ATRR_U                 ;Atributos de la Table Entry
    add ebx, ecx                    ;Mando el puntero a buffer al final
    push ebx                        ;Espacio de memoria de la tarea dónde copiar
    mov eax, cr3
    push eax                        ;Árbol de página

    call __check_paged
    leave

    ;Verifico lo que me retornó
    ;Si retornó 0, la dirección de buffer no está paginada para la tarea llamante
    cmp ax, 0x00
    je exit

  ;Si llegue hasta este punto, significa que está todo paginado
  ;Entonces copio la tabla de digitos
  ;Dado que estoy en nivel 0, puedo utilizar la dirección de la tabla de digitos y acceder a ella
  ;Utilizo __fast_memcpy_ram, es igual a __fast_memcpy pero esta está copiada en RAM
  ;Dado que __fast_memcpy se utiliza sólo en ROM y no puedo llamarla desde RAM

  copy_table:
    push ebp
    mov ebp, esp

    push ecx                        ;Cantidad
    push __TABLA_ORIGIN             ;Origen
    sub ebx, ecx
    push ebx                        ;Destino
    call __fast_memcpy_ram
    leave

  exit:
    popad                           ;Popeo todo lo que pushee
    ret

;System Call para leer la cantidad de enter
;Recibe *buffer -> zona de memoria de la tarea llamante (user nivel 3)
;Se debe copiar __CANT_ENTER en la zona pasada

syscall_enter:
  pushad                            ;Pusheo todos los registros por las dudas

  ;Copio ese byte
  push ebp
  mov ebp, esp

  push ecx                        ;Cantidad
  push __CANT_ENTER               ;Origen
  push ebx                        ;Destino
  call __fast_memcpy_ram
  leave

  popad                           ;Popeo todo lo que pushee
  ret

SECTION .systemcall_funcs progbits

;En esta sección pongo las funciones pedidas por la cátedra
;Son las que van a llamar y pasar los argumentos necesarios para los systemcalls propiamente dichos
;Pág 44 de la ppt de Protección
;Las llaman las Tareas 1 y 2

;Función que llama al halteo
td3_halt:
  push eax

  mov eax, SYS_HALT                 ;Paso eax como "argumento"
                                    ;Le indico a la interrupción qué syscall quiere
  int 0x80                          ;Llamo a la interrupción

  pop eax

  ret

;Función que llama a leer
td3_read:
  ;Pusheo todos los reg que voy a usar
  push eax
  push ebx
  push ecx

  mov eax, SYS_READ                 ;Paso "argumento" a la interrupción de qué syscall quiere
  ;Agarro los argumentos que le llegaron a la función en el stack
  ;Los cargo en algún registro, para pasarselo a la syscall
  mov ebx, [esp + 0x10]             ;Acá le llega el puntero al buffer
  mov ecx, [esp + 0x14]             ;Acá le llega num_bytes

  int 0x80                          ;Llamo a la interrupción

  ;Vuelvo a cargar los valores originales de los registros que use
  pop ecx
  pop ebx
  pop eax

  ret

;Función que llama a leer la Cantidad de entradas
td3_enter:
  push eax
  push ebx
  push ecx

  mov eax, SYS_ENTER                ;Paso "argumento" a la interrupción de qué syscall quiere
  ;Agarro los argumentos que le llegaron a la función en el stack
  ;Lo cargo en ebx
  mov ebx, [esp + 0x10]
  mov ecx, 0x01

  int 0x80

  pop ecx
  pop ebx
  pop eax

  ret
