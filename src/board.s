USE16
SECTION  .start16 progbits

GLOBAL   early_board_init
EXTERN   ..@early_board_init_return
GLOBAL   A20_Enable_No_Stack_return
EXTERN   A20_Enable_No_Stack
EXTERN   PIT_Set_Counter0
EXTERN   PIC_Config
GLOBAL   late_board_init
EXTERN   __STACK_START_16
EXTERN   __STACK_END_16

early_board_init:
    xor   eax, eax
    mov   cr3, eax                  ;Invalidar TLB

    jmp A20_Enable_No_Stack         ;Habilito el stack
    A20_Enable_No_Stack_return:

    ;Inicializo el stack para el llamado a late_board_init
    mov   ax, cs
    mov   ds, ax
    mov   ax, __STACK_START_16
    mov   ss, ax
    mov   sp, __STACK_END_16

    jmp ..@early_board_init_return

late_board_init:
    ;Configuro PIC
    mov bx, 0x2820                  ;Base PIC0=0x20 PIC1=0x28
    call PIC_Config

    ;Deshabilito PIC0 y PIC1
    in al, 0x21                     ;PIC0
    or al, 0xFF
    out 0x21, al

    in al, 0xA1                     ;PIC1
    or al, 0xFF
    out 0xA1, al

    ;Timmer Tick
    ;Seteo que interrumpa cada 10ms
    mov cx, 0x0A
    call PIT_Set_Counter0

    ;Activo las interrupciones de keyboard y timer
    in al, 0x21
    and al, 0xFC
    out 0x21, al

    ret
