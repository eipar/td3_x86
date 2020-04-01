%include "../inc/processor-flags.h"

USE16

SECTION .start16 progbits

GLOBAL  start16
EXTERN  early_board_init
GLOBAL  ..@early_board_init_return
EXTERN  rom_gdtr
EXTERN  CS_SEL_32
EXTERN  late_board_init

start16:
    test  eax, 0x0                  ;Verificar que el uP no este en fallo
    jne   .fault_end

    jmp   early_board_init          ;Callout para agregar funciones de inicializacion
    ..@early_board_init_return:     ;del procesador y controladores escenciales

    o32 lgdt  [cs:rom_gdtr]

    call late_board_init            ;Para inicializar el PIC

    ;->Establecer el up en MP<-
    smsw  ax
    or	 ax, X86_CR0_PE
    lmsw  ax

    ;Hago el jump far para estar en MP
    o32 jmp dword CS_SEL_32:start32_launcher

    .fault_end:
        hlt
        jmp .fault_end

SECTION  .start32 progbits

EXTERN __STACK_END_32
EXTERN __STACK_SIZE_32
EXTERN DS_SEL
EXTERN CS_SEL_32
EXTERN CS_SEL_RAM

EXTERN ram_gdtr
EXTERN rom_idtr
EXTERN Load_IDT

EXTERN page_init

EXTERN main
EXTERN __fast_memcpy

;Kernel
EXTERN ___kernel_size
EXTERN ___kernel_src
EXTERN ___kernel_phy
;Syscalls
EXTERN ___syscall_copysize
EXTERN ___syscall_src
EXTERN ___syscall_phy
;Systables
EXTERN ___sys_table_src
EXTERN ___sys_table_size
EXTERN ___sys_table_phy
;Handlers
EXTERN ___handler_src
EXTERN ___handler_size
EXTERN ___handler_phy
;Tareas (txt)
EXTERN __t0_text_src
EXTERN __t0_text_copysize
EXTERN __t0_text_phy
EXTERN __t1_text_src
EXTERN __t1_text_copysize
EXTERN __t1_text_phy
EXTERN __t2_text_src
EXTERN __t2_text_copysize
EXTERN __t2_text_phy
EXTERN __t3_text_src
EXTERN __t3_text_copysize
EXTERN __t3_text_phy
EXTERN __t4_text_src
EXTERN __t4_text_copysize
EXTERN __t4_text_phy
;Tareas TSS
EXTERN __t0_tss_src
EXTERN __t0_tss_copysize
EXTERN __t0_tss_phy
EXTERN __t1_tss_src
EXTERN __t1_tss_copysize
EXTERN __t1_tss_phy
EXTERN __t2_tss_src
EXTERN __t2_tss_copysize
EXTERN __t2_tss_phy
EXTERN __t3_tss_src
EXTERN __t3_tss_copysize
EXTERN __t3_tss_phy
EXTERN __t4_tss_src
EXTERN __t4_tss_copysize
EXTERN __t4_tss_phy
;Stack Kernel
EXTERN __stack_src
EXTERN __stack_size
EXTERN __stack_phy
EXTERN __TSS_length

EXTERN __last_SIMD


USE32
start32_launcher:

    ;->Inicializar la pila
    mov ax, DS_SEL
    mov ss, ax
    mov esp, __STACK_END_32

    ;->Inicializar la pila
    xor ebx, ebx
    mov ecx, __STACK_SIZE_32
    .stack_init:                    ;Limpia la pila
        push ebx
        loop .stack_init
    mov esp, __STACK_END_32

    ;->Inicializar la selectores datos
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax

    ;Empiezo a desempaquetar todo en RAM

    push ebp                        ;Copio a RAM el kernel
    mov ebp, esp
    push ___kernel_size
    push ___kernel_src
    push ___kernel_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM las system calls
    mov ebp, esp
    push ___syscall_copysize
    push ___syscall_src
    push ___syscall_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM la IDT y la GDT
    mov ebp, esp
    push ___sys_table_size
    push ___sys_table_src
    push ___sys_table_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    lgdt [ram_gdtr]                 ;Recargo la GDT en RAM
                                    ;Esto es debido a que no se página ROM
                                    ;Donde está originalmente ubicada la GDT

    push ebp                        ;Copio a RAM las excepciones
    mov ebp, esp
    push ___handler_size
    push ___handler_src
    push ___handler_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el text de la Tarea 0
    mov ebp, esp
    push __t0_text_copysize
    push __t0_text_src
    push __t0_text_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el text de la Tarea 1
    mov ebp, esp
    push __t1_text_copysize
    push __t1_text_src
    push __t1_text_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el text de la Tarea 2
    mov ebp, esp
    push __t2_text_copysize
    push __t2_text_src
    push __t2_text_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el text de la Tarea 3
    mov ebp, esp
    push __t3_text_copysize
    push __t3_text_src
    push __t3_text_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el text de la Tarea 4
    mov ebp, esp
    push __t4_text_copysize
    push __t4_text_src
    push __t4_text_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el TSS de la Tarea 0
    mov ebp, esp
    push __t0_tss_copysize
    push __t0_tss_src
    push __t0_tss_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el TSS de la Tarea 1
    mov ebp, esp
    push __t1_tss_copysize
    push __t1_tss_src
    push __t1_tss_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el TSS de la Tarea 2
    mov ebp, esp
    push __t2_tss_copysize
    push __t2_tss_src
    push __t2_tss_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el TSS de la Tarea 3
    mov ebp, esp
    push __t3_tss_copysize
    push __t3_tss_src
    push __t3_tss_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el TSS de la Tarea 4
    mov ebp, esp
    push __t4_tss_copysize
    push __t4_tss_src
    push __t4_tss_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    push ebp                        ;Copio a RAM el Stack de Kernel
    mov ebp, esp                    ;Lo hago debido a que en esta sección guardo la TSS de intel
    push 0x00000104
    push __stack_src
    push __stack_phy
    call __fast_memcpy
    leave
    cmp eax, 1                      ;Analizo el valor de retorno (1 Exito -1 Fallo)
    jne .guard

    call Load_IDT                   ;Inicializo la IDT antes de cargarla
    lidt  [rom_idtr]                ;Cargo la IDT

    enter 0,0
    call page_init                  ;Llamado a inicialización de paginas
    leave

    ;Inicializo cuál es la primer tarea que utiliza SIMD
    ;Sino me queda en 0, y no me cumple el salvado/restoreo de contexto
    mov byte [__last_SIMD], 0x01

    jmp CS_SEL_RAM:main

    .guard:
        hlt
        jmp .guard
