%include "../inc/tss.h"

SECTION .funcion_rom progbits

GLOBAL Load_IDT

EXTERN EXC_DE
EXTERN EXC_DB
EXTERN EXC_NMI
EXTERN EXC_BP
EXTERN EXC_OF
EXTERN EXC_BR
EXTERN EXC_UD
EXTERN EXC_NM
EXTERN EXC_DF
EXTERN EXC_TS
EXTERN EXC_NP
EXTERN EXC_SS
EXTERN EXC_GP
EXTERN EXC_PF
EXTERN EXC_MF
EXTERN EXC_MC
EXTERN EXC_AC
EXTERN EXC_XF
EXTERN EXC_VE
EXTERN IRQ0
EXTERN IRQ1
EXTERN IRQ128

EXTERN IRQ0_Handler
EXTERN IRQ128_Handler

USE32

;**************************************
;***Función para cargar los handlers***
;**************************************

Load_IDT:

    mov eax, DE_Handler         ;Dirección de la rutina de excepción
    mov [EXC_DE], ax            ;Cargo en la tabla el offset de IDT
                                ;Así lo hago en todas las excepciones
    mov eax, DB_Handler
    mov [EXC_DB], ax

    mov eax, NMI_Handler
    mov [EXC_NMI], ax

    mov eax, BP_Handler
    mov [EXC_BP], ax

    mov eax, OF_Handler
    mov [EXC_OF], ax

    mov eax, BR_Handler
    mov [EXC_BR], ax

    mov eax, UD_Handler
    mov [EXC_UD], ax

    mov eax, NM_Handler
    mov [EXC_NM], ax

    mov eax, DF_Handler
    mov [EXC_DF], ax

    mov eax, TS_Handler
    mov [EXC_TS], ax

    mov eax, NP_Handler
    mov [EXC_NP], ax

    mov eax, SS_Handler
    mov [EXC_SS], ax

    mov eax, GP_Handler
    mov [EXC_GP], ax

    mov eax, PF_Handler
    mov [EXC_PF], ax

    mov eax, MF_Handler
    mov [EXC_MF], ax

    mov eax, AC_Handler
    mov [EXC_AC], ax

    mov eax, MC_Handler
    mov [EXC_MC], ax

    mov eax, XF_Handler
    mov [EXC_XF], ax

    mov eax, VE_Handler
    mov [EXC_VE], ax

    mov eax, IRQ0_Handler       ;Cargo el offset del Handler del Timmer Tick
    mov [IRQ0], ax

    mov eax, IRQ1_Handler       ;Cargo el offset del Handler del Timmer Tick
    mov [IRQ1], ax

    mov eax, IRQ128_Handler      ;Cargo el offset del Handler del llamado a System Calls
    mov [IRQ128], ax

    ret

SECTION .handlers progbits

EXTERN __BUFF_CIRC_INDEX
EXTERN __BUFF_CIRC
EXTERN __CANT_ENTER
EXTERN __TABLA_ORIGIN
EXTERN __keyboard_int_handler
EXTERN __pagefault_handler

EXTERN __last_SIMD
EXTERN __tarea_actual

EXTERN __PT_START_T1
EXTERN __PT_START_T2
EXTERN __PT_START_T3
EXTERN __PT_START_T4

EXTERN TAREA_1_SIMD
EXTERN TAREA_2_SIMD
EXTERN TAREA_0_SIMD

USE32

;*******************
;****Excepciones****
;*******************

DE_Handler:             ;Excepción 0 - Divide Error
    ;xchg bx, bx         ;Magic Breakpoint
    xor dx, dx
    mov dx, 0
    jmp handler_hlt

DB_Handler:             ;Excepción 1 - Debug Exception Fault/Trap
    xor dx, dx
    mov dx, 1
    jmp handler_hlt

NMI_Handler:            ;Excepción 2 - NMI
    xor dx, dx
    mov dx, 2
    jmp handler_hlt

BP_Handler:             ;Excepción 3 - Breakpoint
    xor dx, dx
    mov dx, 3
    jmp handler_hlt

OF_Handler:             ;Excepción 4 - Overflow
    xor dx, dx
    mov dx, 4
    jmp handler_hlt

BR_Handler:             ;Excepción 5 - Bound Range Exceeded
    xor dx, dx
    mov dx, 5
    jmp handler_hlt

UD_Handler:             ;Excepción 6 - Undefined Opcode
    ;xchg bx, bx         ;Magic Breakpoint
    xor dx, dx
    mov dx, 6
    jmp handler_hlt

NM_Handler:             ;Excepción 7 - Device not available
  ;Se activa esta excepción cuando se desea ejecutar una instrucción SIMD
  ;Y CR0.TS está activo alto

  push eax

  ;Limpio el bit CR0.TS
  clts

  xor eax, eax                  ;Limpio eax

  ;Me fijo la última tarea que usó SIMD
  mov byte al, [__last_SIMD]
  ;Si es igual a la tarea actual, salgo
  ;Porque no tengo que restorear nada
  cmp byte al, [__tarea_actual]
  je exit
  ;Tengo que verificar qué tarea lo uso por última vez
  ;Para cargar su CR3

  cmp al, TAREA_1               ;Es la t1?
  je save_t1

  cmp al, TAREA_2               ;O la t2?
  je save_t2

  cmp al, TAREA_3               ;O la t3?
  je save_t3

  cmp al, TAREA_4               ;O la t4?

save_t1:
  ;xchg bx, bx
  mov eax, __PT_START_T1        ;Cargo el cr3 de la tarea 1
  jmp save_all

save_t2:
  mov eax, __PT_START_T2        ;Cargo el cr3 de la tarea 2
  jmp save_all

save_t3:
  mov eax, __PT_START_T3        ;Cargo el cr3 de la tarea 3
  jmp save_all

save_t4:
  mov eax, __PT_START_T4        ;Cargo el cr3 de la tarea 4
  jmp save_all

save_all:
  mov cr3, eax                  ;Lo cargo al registro

  ;Guardo todo el contexto de SIMD
  ;Como es todo la misma dirección lineal, hice uno de tarea 0
  ;Para usar la misma etiqueta
  ;Pero distinto lugar por el cr3
  fxsave [TAREA_0_SIMD]

  ;Una vez que guarde los registros
  ;Tengo que volver a cargar el cr3 pero de la tarea actual
  ;Porque es la que quiere hacer uso de los registros mmx

  xor eax, eax
  mov byte al, [__tarea_actual]

  cmp al, TAREA_1
  je rstor_t1

  cmp al, TAREA_2
  je rstor_t2

  cmp al, TAREA_3
  je rstor_t3

  cmp al, TAREA_4
  je rstor_t4

rstor_t1:
  mov eax, __PT_START_T1               ;Cargo el cr3 de la tarea 1
  mov byte [__last_SIMD], TAREA_1      ;Actualizo la última tarea que utilizó SIMD
  jmp rstor_all

rstor_t2:
  mov eax, __PT_START_T2              ;Cargo el cr3 de la tarea 2
  mov byte [__last_SIMD], TAREA_2     ;Actualizo la última tarea que utilizó SIMD
  jmp rstor_all

rstor_t3:
  mov eax, __PT_START_T3              ;Cargo el cr3 de la tarea 3
  mov byte [__last_SIMD], TAREA_3     ;Actualizo la última tarea que utilizó SIMD
  jmp rstor_all

rstor_t4:
  mov eax, __PT_START_T4              ;Cargo el cr3 de la tarea 4
  mov byte [__last_SIMD], TAREA_4     ;Actualizo la última tarea que utilizó SIMD
  jmp rstor_all

rstor_all:
  mov cr3, eax                  ;Lo cargo al registro

  fxrstor [TAREA_0_SIMD]        ;Acá se aplica lo mismo de la lineal/física de antes

exit:
  pop eax

  iret

DF_Handler:             ;Excepción 8 - Double Fault
    ;xchg bx, bx         ;Magic Breakpoint
    xor dx, dx
    mov dx, 8
    jmp handler_hlt

TS_Handler:             ;Excepción 10 - Invalid TSS
    xor dx, dx
    mov dx, 10
    jmp handler_hlt

NP_Handler:             ;Excepción 11 - Segment not present
    xor dx, dx
    mov dx, 11
    jmp handler_hlt

SS_Handler:             ;Excepción 12 - Stack Fault
    xor dx, dx
    mov dx, 12
    jmp handler_hlt

GP_Handler:             ;Excepción 13 - General Protection
    xchg bx, bx         ;Magic Breakpoint
    xor dx, dx
    mov dx, 13
    jmp handler_hlt

PF_Handler:             ;Excepción 14 - Page Fault
    xchg bx, bx         ;Magic Breakpoint

    ;pushad

    ;mov eax, cr2          ;Paso CR2 que contiene la dirección lineal que causó el PF
    ;mov ebx, [esp]        ;Paso a ebx el Error Code
    ;mov edx, cr3          ;Paso CR3 para crear la página en el árbol correspondiente

    ;push ebp
    ;mov ebp, esp
    ;push ebx              ;Error Code
    ;push eax              ;CR2 - Dirección Lineal
    ;push edx              ;CR3 - ptree base
    ;call __pagefault_handler
    ;leave

    ;popad
    ;add esp, 4            ;Se limpia el Error Code de la pila
    iret

MF_Handler:             ;Excepción 16 - Floating-Point Error
    xor dx, dx
    mov dx, 16
    jmp handler_hlt

AC_Handler:             ;Excepción 17 - Alignment Check
    xor dx, dx
    mov dx, 17
    jmp handler_hlt

MC_Handler:             ;Excepción 18 - Machine-Check
    xor dx, dx
    mov dx, 18
    jmp handler_hlt

XF_Handler:             ;Excepción 19 - SIMD Floating-Point
    xor dx, dx
    mov dx, 19
    jmp handler_hlt

VE_Handler:             ;Excepción 20 - Virtualization
    xor dx, dx
    mov dx, 20
    jmp handler_hlt

;******************
;**Interrupciones**
;******************

;El IRQ0_Handler está bajo el archivos scheduler.s
;Dado que funciona como scheduler y preferí ponerlo
;en un archivo a parte

IRQ1_Handler:           ;Keyboard - Interrupción
  pushad

  push ebp
  mov ebp, esp
  push __BUFF_CIRC_INDEX            ;Índice
  push __BUFF_CIRC                  ;Auxiliar del buffer circular
  push __CANT_ENTER                 ;Cantidad de Enters
  push __TABLA_ORIGIN               ;Origen de la tabla de dígitos
  call __keyboard_int_handler
  leave

  mov al, 0x20                    ;Ya terminó la interrupción
  out 0x20, al
  popad                           ;Popeo todos los registros
  iret                            ;Return desde interrupción

handler_hlt:
  nop
  hlt
  jmp handler_hlt
