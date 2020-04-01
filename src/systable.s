SECTION	.GDT_table_ram progbits alloc noexec nowrite

;Etiquetas de GDT
GLOBAL CS_SEL_RAM
GLOBAL DS_SEL_RAM
GLOBAL CS_SEL_N3
GLOBAL DS_SEL_N3
GLOBAL TSS
GLOBAL GDT_LENGTH_RAM
GLOBAL ram_gdtr

EXTERN TSS_Global
EXTERN __TSS_descr_15_0
EXTERN __TSS_descr_23_16
EXTERN __TSS_descr_31_24
EXTERN __TSS_length_15_0
EXTERN __TSS_length_19_16

;***************
;******GDT******
;***************

GDT_RAM:
NULL_SEL_RAM    equ $-GDT_RAM
    dq 0x0
CS_SEL_RAM      equ $-GDT_RAM
    dw 0xFFFF             ;Límite 0-15
    dw 0x0000             ;Base 0-15
    db 0x00               ;Base 16-23
    db 0x9A               ;Atributos
    db 0xCF               ;Atributos + Límite 19-16
    db 0                  ;Base 31-24
DS_SEL_RAM      equ $-GDT_RAM
    dw 0xFFFF             ;Límite 0-15
    dw 0x0000             ;Base 0-15
    db 0x00               ;Base 16-23
    db 0x92               ;Atributos
    db 0xCF               ;Atributos + Límite 19-16
    db 0                  ;Base 31-24
;Agrego esta sección que tengo los selectores de código y datos de nivel 3
;Cambia que el DPL es 11 ahora
CS_SEL_N3       equ $-GDT_RAM + 0x03
    dw 0xFFFF             ;Límite 0-15
    dw 0x0000             ;Base 0-153
    db 0x00               ;Base 16-23
    db 0xFA               ;Atributos
    db 0xCF               ;Atributos + Límite 19-16
    db 0                  ;Base 31-24
DS_SEL_N3       equ $-GDT_RAM + 0x03
    dw 0xFFFF             ;Límite 0-15
    dw 0x0000             ;Base 0-15
    db 0x00               ;Base 16-23
    db 0xF2               ;Atributos
    db 0xCF               ;Atributos + Límite 19-16
    db 0                  ;Base 31-24
;Descriptor de la TSS de intel
TSS             equ $-GDT_RAM
    dw 0x0068             ;Límite 0-15
    dw __TSS_descr_15_0   ;Base 0-15
    db __TSS_descr_23_16  ;Base 16-23
    db 0x89               ;Atributos
    db 0xC0               ;Atributos + Límite 19-16
    db __TSS_descr_31_24  ;Base 31-24
GDT_LENGTH_RAM  equ $-GDT_RAM

ram_gdtr:
    dw GDT_LENGTH_RAM-1       ;Tamaño de la Tabla
    dd GDT_RAM                ;Dirección de la Tabla

SECTION	.GDT_table progbits alloc noexec nowrite

;Etiquetas de GDT
GLOBAL CS_SEL_32
GLOBAL DS_SEL
GLOBAL GDT_LENGTH
GLOBAL rom_gdtr

;***************
;******GDT******
;***************

GDT_ROM:
NULL_SEL    equ $-GDT_ROM
    dq 0x0
CS_SEL_32   equ $-GDT_ROM
    dw 0xFFFF           ;Límite 0-15
    dw 0x0000           ;Base 0-15
    db 0x00             ;Base 16-23
    db 0x99             ;Atributos
    db 0xCF             ;Atributos + Límite 19-16
    db 0                ;Base 31-24
DS_SEL     equ $-GDT_ROM
    dw 0xFFFF           ;Límite 0-15
    dw 0x0000           ;Base 0-15
    db 0x00             ;Base 16-23
    db 0x92             ;Atributos
    db 0xCF             ;Atributos + Límite 19-16
    db 0                ;Base 31-24
GDT_LENGTH  equ $-GDT_ROM

rom_gdtr:
    dw GDT_LENGTH-1           ;Tamaño de la Tabla
    dd GDT_ROM                ;Dirección de la Tabla

SECTION	.IDT_table progbits alloc noexec nowrite

%define TRAP_GATE 0x8F
%define IRQ_GATE  0x8E
%define SYS_GATE  0xEF

;Etiquetas de IDT
GLOBAL rom_idtr
GLOBAL IDT_LENGTH
GLOBAL EXC_DE
GLOBAL EXC_DB
GLOBAL EXC_NMI
GLOBAL EXC_BP
GLOBAL EXC_OF
GLOBAL EXC_BR
GLOBAL EXC_UD
GLOBAL EXC_NM
GLOBAL EXC_DF
GLOBAL EXC_TS
GLOBAL EXC_NP
GLOBAL EXC_SS
GLOBAL EXC_GP
GLOBAL EXC_PF
GLOBAL EXC_MF
GLOBAL EXC_MC
GLOBAL EXC_AC
GLOBAL EXC_XF
GLOBAL EXC_VE
GLOBAL IRQ0
GLOBAL IRQ1
GLOBAL IRQ128

;***************
;******IDT******
;***************

IDT:
EXC_DE:             ;#0 - Divide Error #DE
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_DB:             ;#1 - Debug #DB
    dq 0x0
EXC_NMI:            ;#2 - NMI Interrupt
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_BP:             ;#3 - Breakpoint #BP
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_OF:             ;#4 - Overflow #OF
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_BR:             ;#5 - BOUND Range Exceeded #BR
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_UD:             ;#6 - Invalid Opcode #UD
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_NM:             ;#7 - Device Not Available #NM
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_DF:             ;#8 - Double Fault #DF
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_R9:             ;#9 - Coprocessor Segment Overrun
    dq 0x0
EXC_TS:             ;#10 - Invalid TSS #TS
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_NP:             ;#11 - Segment Not Present #NP
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_SS:             ;#12 - Stack Fault #SS
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_GP:             ;#13 - General Protection #GP
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_PF:             ;#14 - Page-Fault #PF
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_R15:            ;#15
    dq 0x0
EXC_MF:             ;#16 - x87 FPU Floating Point #MF
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_AC:             ;#17 - Alignment Check #AC
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_MC:             ;#18 - Machine Check #MC
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_XF:             ;#19 - SIMD Floating Point #XM
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db TRAP_GATE
    dw 0x0000
EXC_VE:             ;#20 - Virtualization #VE
    times 12 dq 0x0
IRQ0:               ;Timer Tick (IRQ32)
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db IRQ_GATE
    dw 0x0000
IRQ1:               ;Keyboard (IRQ33)
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db IRQ_GATE
    dw 0x0000
;Interrupt 34 to 255 - User Defined Interrupts
IRQ34:                ;Disponible para el Usuario
    times 94 dq 0x0   ;IRQ34 a IRQ127
IRQ128:             ;System Call (IRQ128 - 80h)
    dw 0x0000
    dw CS_SEL_32
    db 0x00
    db SYS_GATE
    dw 0x0000

IDT_LENGTH equ $-IDT

rom_idtr:
    dw IDT_LENGTH-1      ;Tamaño de la Tabla
    dd IDT               ;Dirección de la Tabla
