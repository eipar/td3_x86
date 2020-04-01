%include "../inc/tss.h"

USE32

GLOBAL IRQ0_Handler

GLOBAL TAREA_1_SIMD
GLOBAL TAREA_2_SIMD
GLOBAL TAREA_0_SIMD
GLOBAL TAREA_3_SIMD
GLOBAL TAREA_4_SIMD

EXTERN __tarea_prox
EXTERN __tarea_actual
EXTERN __timer_count_t1
EXTERN __timer_count_t2
EXTERN __timer_count_t3
EXTERN __timer_count_t4
EXTERN T1_timer_max
EXTERN T2_timer_max
EXTERN T3_timer_max
EXTERN T4_timer_max

EXTERN CS_SEL_RAM
EXTERN DS_SEL_RAM
EXTERN CS_SEL_N3
EXTERN DS_SEL_N3

EXTERN __PT_START_T0
EXTERN __PT_START_T1
EXTERN __PT_START_T2
EXTERN __PT_START_T3
EXTERN __PT_START_T4

EXTERN __STACK_T0_END
EXTERN __STACK_T1_END
EXTERN __STACK_T2_END
EXTERN __STACK_T3_END
EXTERN __STACK_T4_END

EXTERN __T0_TSS_START
EXTERN __T1_TSS_START
EXTERN __T2_TSS_START
EXTERN __T3_TSS_START
EXTERN __T4_TSS_START

EXTERN __T0_TSS_END
EXTERN __T1_TSS_END
EXTERN __T2_TSS_END
EXTERN __T3_TSS_END
EXTERN __T4_TSS_END

EXTERN __t0_text_dst
EXTERN __t1_text_dst
EXTERN __t2_text_dst
EXTERN __t3_text_dst
EXTERN __t4_text_dst

;TSS Global de Intel
SECTION .tss_global progbits

;No utilizo esta TSS dado que se utiliza para el switcheo automático de tareas
;Lo hago de forma manual
;Pero se necesita al menos una TSS para poder hacer el switcheo
;Para que cuando haga un cambio de privilegio, pueda rescatar dónde esta la pila nivel 0 (kernel)
;Entonces sólo le cargo el ss0 y esp0

TSS_Global:
  istruc   tss_t
    at tss_t.previous_task_link,  dw 0
    at tss_t.rsvd0,               dw 0
    at tss_t.reg_esp0,            dd __T0_TSS_END
    at tss_t.reg_ss0,             dw DS_SEL_RAM
    at tss_t.rsvd1,               dw 0
    at tss_t.reg_esp1,            dd 0
    at tss_t.reg_ss1,             dw 0
    at tss_t.rsvd2,               dw 0
    at tss_t.reg_esp2,            dd 0
    at tss_t.reg_ss2,             dw 0
    at tss_t.rsvd3,               dw 0
    at tss_t.reg_cr3,             dd 0
    at tss_t.reg_eip,             dd 0
    at tss_t.reg_eflags,          dd 0
    at tss_t.reg_eax,             dd 0
    at tss_t.reg_ecx,             dd 0
    at tss_t.reg_edx,             dd 0
    at tss_t.reg_ebx,             dd 0
    at tss_t.reg_esp,             dd 0
    at tss_t.reg_ebp,             dd 0
    at tss_t.reg_esi,             dd 0
    at tss_t.reg_edi,             dd 0
    at tss_t.reg_es,              dw 0
    at tss_t.rsvd4,               dw 0
    at tss_t.reg_cs,              dw 0
    at tss_t.rsvd5,               dw 0
    at tss_t.reg_ss,              dw 0
    at tss_t.rsvd6,               dw 0
    at tss_t.reg_ds,              dw 0
    at tss_t.rsvd7,               dw 0
    at tss_t.reg_fs,              dw 0
    at tss_t.rsvd8,               dw 0
    at tss_t.reg_gs,              dw 0
    at tss_t.rsvd9,               dw 0
    at tss_t.LTD_ss,              dw 0
    at tss_t.rsvd10,              dw 0
    at tss_t.rsvd11,              dw 0
    at tss_t.io_map_base_addr,    dw 0
  iend

;Acá en estas 3 secciones distintas voy a cargar los datos de cada TSS propia
;Según la tarea que sea
;Donde empieza cada stack, cada cr3, y demás
;Cada una de estas secciones tiene la misma dirección LINEAL, pero distinta FÍSICA
;Por eso depsués uso la etiqueta de una sola para cargar contexto

SECTION .t0_tss progbits

TAREA_0_TSS:
  istruc   tss_t
    at tss_t.reg_esp0   , dd __T0_TSS_END
    at tss_t.reg_ss0    , dw DS_SEL_RAM
    at tss_t.reg_cr3    , dd __PT_START_T0
    at tss_t.reg_eip    , dd __t0_text_dst ;+ 0x00       ;Agrego la suma sino me putea
    at tss_t.reg_eflags , dd 0x202
    at tss_t.reg_esp    , dd __STACK_T0_END ;- 0x04
    at tss_t.reg_es     , dw DS_SEL_RAM
    at tss_t.reg_cs     , dw CS_SEL_RAM
    at tss_t.reg_ss     , dw DS_SEL_RAM
    at tss_t.reg_ds     , dw DS_SEL_RAM
  iend

ALIGN 16
TAREA_0_SIMD:
  times 512 db 0

SECTION .t1_tss progbits

TAREA_1_TSS:
  istruc   tss_t
    at tss_t.reg_esp0   , dd __T1_TSS_END
    at tss_t.reg_ss0    , dw DS_SEL_RAM
    at tss_t.reg_cr3    , dd __PT_START_T1
    at tss_t.reg_eip    , dd __t1_text_dst ;+ 0x00
    at tss_t.reg_eflags , dd 0x202
    at tss_t.reg_esp    , dd __STACK_T1_END - 0x04
    at tss_t.reg_es     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_cs     , dw CS_SEL_N3 ;+ 0x03
    at tss_t.reg_ss     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_ds     , dw DS_SEL_N3 ;+ 0x03
  iend

ALIGN 16
TAREA_1_SIMD:
  times 512 db 0
;Reservo en la Sección de TSS de la Tarea 1
;los 512Bytes que necesita SIMD para resguardar
;todos los registros

SECTION .t2_tss progbits

TAREA_2_TSS:
  istruc   tss_t
    at tss_t.reg_esp0   , dd __T2_TSS_END
    at tss_t.reg_ss0    , dw DS_SEL_RAM
    at tss_t.reg_cr3    , dd __PT_START_T2
    at tss_t.reg_eip    , dd __t2_text_dst ;+ 0x00
    at tss_t.reg_eflags , dd 0x202
    at tss_t.reg_esp    , dd __STACK_T2_END - 0x04
    at tss_t.reg_es     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_cs     , dw CS_SEL_N3 ;+ 0x03
    at tss_t.reg_ss     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_ds     , dw DS_SEL_N3 ;+ 0x03
  iend

ALIGN 16
TAREA_2_SIMD:
  times 512 db 0
;Reservo en la Sección de TSS de la Tarea 2
;los 512Bytes que necesita SIMD para resguardar
;todos los registros

SECTION .t3_tss progbits

TAREA_3_TSS:
  istruc   tss_t
    at tss_t.reg_esp0   , dd __T3_TSS_END
    at tss_t.reg_ss0    , dw DS_SEL_RAM
    at tss_t.reg_cr3    , dd __PT_START_T3
    at tss_t.reg_eip    , dd __t3_text_dst ;+ 0x00
    at tss_t.reg_eflags , dd 0x202
    at tss_t.reg_esp    , dd __STACK_T3_END - 0x04
    at tss_t.reg_es     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_cs     , dw CS_SEL_N3 ;+ 0x03
    at tss_t.reg_ss     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_ds     , dw DS_SEL_N3 ;+ 0x03
  iend

ALIGN 16
TAREA_3_SIMD:
  times 512 db 0
;Reservo en la Sección de TSS de la Tarea 3
;los 512Bytes que necesita SIMD para resguardar
;todos los registros

SECTION .t4_tss progbits

TAREA_4_TSS:
  istruc   tss_t
    at tss_t.reg_esp0   , dd __T4_TSS_END
    at tss_t.reg_ss0    , dw DS_SEL_RAM
    at tss_t.reg_cr3    , dd __PT_START_T4
    at tss_t.reg_eip    , dd __t4_text_dst ;+ 0x00
    at tss_t.reg_eflags , dd 0x202
    at tss_t.reg_esp    , dd __STACK_T4_END - 0x04
    at tss_t.reg_es     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_cs     , dw CS_SEL_N3 ;+ 0x03
    at tss_t.reg_ss     , dw DS_SEL_N3 ;+ 0x03
    at tss_t.reg_ds     , dw DS_SEL_N3 ;+ 0x03
  iend

ALIGN 16
TAREA_4_SIMD:
  times 512 db 0
;Reservo en la Sección de TSS de la Tarea 4
;los 512Bytes que necesita SIMD para resguardar
;todos los registros


SECTION .handlers progbits

;Interrupción del Timer Tick
;Va a funcionar como scheduler también

IRQ0_Handler:
  push eax                          ;Pusheo eax

  mov al, 0x20                      ;Ya termino la interrupción
  out 0x20, al

;IRQ0 interrumpe cada 10ms

;Tarea 1 - Switchea cada 100ms
;Incremento el contador de la Tarea 1
  inc byte [__timer_count_t1]

;Tarea 2 - Switchea cada 200ms
;Incremento el contador de la Tarea 2
  inc byte [__timer_count_t2]

;Tarea 3 - Switchea cada 300ms
;Incremento el contador de la Tarea 3
  inc byte [__timer_count_t3]

;Tarea 4 - Switchea cada 400ms
;Incremento el contador de la Tarea 4
  inc byte [__timer_count_t4]

normal_scheduler:
;Comparo a ver si tengo que switchear las tareas
  cmp byte [__timer_count_t1], T1_timer_max
  je ready_t1                               ;Hay que switchear a la Tarea 1

  cmp byte [__timer_count_t2], T2_timer_max
  je ready_t2                               ;Hay que switchear a la Tarea 2

  cmp byte [__timer_count_t3], T3_timer_max
  je ready_t3                               ;Hay que switchear a la Tarea 3

  cmp byte [__timer_count_t4], T4_timer_max
  je ready_t4                               ;Hay que switchear a la Tarea 4

  mov byte [__tarea_prox], TAREA_0          ;Sigo en la Tarea 0
  jmp task_change

  ;Según la tarea, reseteo el contador y cargo que es la prox tarea a la que tengo que ir
  ready_t1:
    mov byte [__timer_count_t1], 0x00       ;Reseteo el contador
    mov byte [__tarea_prox], TAREA_1        ;Indico que la prox tarea es la 1
    jmp task_change                         ;Indico la tarea nueva

  ready_t2:
    mov byte [__timer_count_t2], 0x01       ;Reseteo el contador
    mov byte [__tarea_prox], TAREA_2        ;Indico que la prox tarea es la 2
    jmp task_change                         ;Indico la tarea nueva

  ready_t3:
    mov byte [__timer_count_t3], 0x02       ;Reseteo el contador
    mov byte [__tarea_prox], TAREA_3        ;Indico que la prox tarea es la 3
    jmp task_change                         ;Indico la tarea nueva

  ready_t4:
    mov byte [__timer_count_t4], 0x03       ;Reseteo el contador
    mov byte [__tarea_prox], TAREA_4        ;Indico que la prox tarea es la 4
    jmp task_change                         ;Indico la tarea nueva

  ;Cambio de tarea
  ;Si tengo que seguir en la misma tarea, popeo eax que es el único que use y salgo
  ;Esto es en caso de que no se termino de ejecutar T1 o T2 y ya hay otra IRQ0
  ;O si tengo que seguir en la tarea 0 dado que no es el tiempo de las otras
  task_change:
    mov byte al, [__tarea_prox]
    cmp byte [__tarea_actual], al

    pop eax
    je exit

  ;Si tengo que cambiar de tarea, tengo que hacer el cambio de contexto
  ;Es decir, guardar todos los registros necesarios y
  ;Cambiar el CR3 al de la tarea a ejecutar, para ver sólo SU árbol de páginas
  ;Todo se va a hacer en base el TSS0 debido a que al cambiar el CR3 al de cada tarea
  ;Y que todas tienen la misma dirección lineal, pero diferente física
  ;A nivel código todo está en la misma ubicación, pero la paginación me resuelve el
  ;Donde está REALMENTE cada una de esas cosas
  ;Esa es la magia de la paginación

  save_context:
    ;Guardo los registros que puedo guardar de una
    mov dword [TAREA_0_TSS+tss_t.reg_eax], eax
    mov dword [TAREA_0_TSS+tss_t.reg_ebx], ebx
    mov dword [TAREA_0_TSS+tss_t.reg_ecx], ecx
    mov dword [TAREA_0_TSS+tss_t.reg_edx], edx
    mov dword [TAREA_0_TSS+tss_t.reg_edi], edi
    mov dword [TAREA_0_TSS+tss_t.reg_esi], esi
    ;Guardo eip
    pop eax
    mov dword [TAREA_0_TSS+tss_t.reg_eip], eax
    ;Guardo cs
    pop eax
    mov word [TAREA_0_TSS+tss_t.reg_cs], ax
    ;Guardo los registros que pasan por acumulador
    mov eax, ds
    mov word [TAREA_0_TSS+tss_t.reg_ds], ax
    ;mov eax, ss
    ;mov word [TAREA_0_TSS+tss_t.reg_ss], ax
    mov eax, es
    mov word [TAREA_0_TSS+tss_t.reg_es], ax
    mov eax, cr3
    mov dword [TAREA_0_TSS+tss_t.reg_cr3], eax
    ;Guardo eflags
    pop eax
    mov dword [TAREA_0_TSS+tss_t.reg_eflags], eax
    mov dword [TAREA_0_TSS+tss_t.reg_ebp], ebp

  ;Dependiendo de qué nivel de privilegios es mi tarea actual
  ;Es cómo tengo que guardar esp
  ;Si viene de la tarea 0, lo guardo directamente del registro esp
  ;Pero si vengo de las tareas 1 o 2 (nivel 3), tengo que popear del stack esp y ss
  ;Dado que cuando voy de tarea nivel 3 a tarea nivel 0, se pushea el esp y ss nivel 3
  ;Además de eflags, cs e eip

  ;Para ver de qué nivel de tarea vengo
  ;Verifico el cs cargado al cs de nivel 0
  ;Esto es, porque capaz el scheduler interrumpio a la tarea 1 o 2 pero en el momento de un syscall
  ;Que es nivel 0 y no pushea el esp y ss de nivel 3
  ;Si no lo compruebo, me busca en la pila cosas que no están
  ;Queda todo desalineado y sin funcionar
  where_is_it_coming:
    cmp word [TAREA_0_TSS+tss_t.reg_cs], CS_SEL_RAM  ;única tarea con lvl 00
    je from_register

  from_stack:
    pop eax                                           ;Popeo del stack esp
    mov dword [TAREA_0_TSS+tss_t.reg_esp], eax
    pop eax                                           ;Popeo del stack ss
    mov word [TAREA_0_TSS+tss_t.reg_ss], ax
    jmp is_tarea0                                     ;Que vaya a chequear a que tarea tengo que ir

  from_register:
    mov dword [TAREA_0_TSS+tss_t.reg_esp0], esp       ;Simpelmente cargo del registro, porque estaría en nivel 0

  ;Una vez guardado el contexto
  ;Tengo que cambiar el CR3 así cambio el árbol de paginación en el que estoy parada
  ;Tengo que hacer todos ifs anidados para verificar qué tarea es y cambiar al CR3 correspondiente

  ;Qué tarea es la próxima?
  is_tarea0:
    cmp byte [__tarea_prox], TAREA_0
    je yes_tarea0

  is_tarea1:
    cmp byte [__tarea_prox], TAREA_1
    je yes_tarea1

  is_tarea2:
    cmp byte [__tarea_prox], TAREA_2
    je yes_tarea2

  is_tarea3:
    cmp byte [__tarea_prox], TAREA_3
    je yes_tarea3

  is_tarea4:
    cmp byte [__tarea_prox], TAREA_4
    je yes_tarea4

  ;Cargo el CR3 de la tarea a la que tengo que ir
  yes_tarea0:
    mov eax, __PT_START_T0
    jmp new_tree

  yes_tarea1:
    mov eax, __PT_START_T1
    jmp new_tree

  yes_tarea2:
    mov eax, __PT_START_T2
    jmp new_tree

  yes_tarea3:
    mov eax, __PT_START_T3
    jmp new_tree

  yes_tarea4:
    mov eax, __PT_START_T4
    jmp new_tree

  new_tree:
    ;Para cambiar el cr3 simplemente hago un mov con lo cargado previamente
    mov cr3, eax
    ;Recargo el puntero de nivel 0 del árbol de paginación en el que estoy
    mov dword esp, [TAREA_0_TSS+tss_t.reg_esp0]

    ;Actualizo mi tarea actual, es decir, la que voy a cargar el contexto
    mov byte al, [__tarea_prox]
    mov byte [__tarea_actual], al

  ;Antes de recargar el contexto completo
  ;Verifico si va a una tarea con el mismo nivel de privilegios o con otro
  ;Esto me va a cambiar lo que pusheo o no al Stack
  ;Dado que si tengo que ir a otro con diff niveles de priv, tengo que mandar al stack
  ;ss y esp de nivel 3 (es lo que espera la tarea, además de eip cs eflags)
  is_it_diff_privilige:
    mov ax, [TAREA_0_TSS+tss_t.reg_cs]            ;Comparo el CS actual con el que deberia ir
    and dword eax, 0x0000FFFF
    mov bx, cs
    cmp ax, bx
    jne diff_priv

  ;En este caso iría a una del mismo nivel de privilegio
  ;No se debe pushear al stack ss y esp
  same_priv:
    mov dword esp, [TAREA_0_TSS+tss_t.reg_esp0]    ;Guardo el esp de nivel 0
    jmp load_context

  ;Como hace un cambio de privilegios, se deben poner esp y ss en la pila
  ;Todos estos serán de nivel 3
  diff_priv:
    mov word ax, [TAREA_0_TSS+tss_t.reg_ss]       ;Cargo el ss niv 3
    and dword eax, 0x0000FFFF                     ;Le limpio los 2 bytes MS (para no guardar basura)
    push eax                                      ;Lo mando al stack
    mov dword eax, [TAREA_0_TSS+tss_t.reg_esp]    ;Cargo el esp niv 3
    push eax                                      ;Lo mando al stack

  ;En este punto, al cargar el nuevo CR3, ya estoy viendo otro árbol de paginación
  ;El lugar donde tengo TAREA_0_TSS, tiene que tener la misma dirección lineal en todos los árboles
  ;Así se puede ejecutar sin problema
  ;De esta forma, cargo el contexto de la tarea nueva que voy a ejecutar

  load_context:
    mov word ax, [TAREA_0_TSS + tss_t.reg_ds]
    mov ds, eax
    mov word ax, [TAREA_0_TSS + tss_t.reg_es]
    mov es, eax
    mov dword ebp, [TAREA_0_TSS + tss_t.reg_ebp]
    ;EFlags -> Debe pushearse a la pila
    mov dword eax, [TAREA_0_TSS + tss_t.reg_eflags]
    or dword eax, 0x0202                                  ;Le habilito las interrupciones
    push eax
    ;CS -> Debe pushearse a la pila
    mov word ax, [TAREA_0_TSS + tss_t.reg_cs]
    and dword eax, 0x0000FFFF                             ;Lo limpio para no copiar basura
    push eax
    ;EIP -> Debe pushearse a la pila
    mov dword eax, [TAREA_0_TSS + tss_t.reg_eip]
    push eax
    ;Ya puedo prescindir de eax
    ;Recargo todos los otros registros
    mov dword eax, [TAREA_0_TSS + tss_t.reg_eax]
    mov dword ebx, [TAREA_0_TSS + tss_t.reg_ebx]
    mov dword ecx, [TAREA_0_TSS + tss_t.reg_ecx]
    mov dword edx, [TAREA_0_TSS + tss_t.reg_edx]
    mov dword edi, [TAREA_0_TSS + tss_t.reg_edi]
    mov dword esi, [TAREA_0_TSS + tss_t.reg_esi]

    ;Hubo switcheo de tarea así que hay que activar el CR0.TS
    ;Para que se active la excepción #NM cuando se use una
    ;instrucción SIMD
    mov eax, cr0
    or eax, 0x00000008
    mov cr0, eax

  ;Finalmente ya salimos
  ;Según el CR3 cargado, será a la tarea que vuelve
  exit:
    iret
