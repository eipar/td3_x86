;Task State Register
;Se aprovecha el formato de Intel
;No se utiliza el switcheo automático, sólo es para poder hacerlo manual

struc   tss_t
   .previous_task_link:     resw 1    ;No utilizado - Link a la tarea previa anidada
   .rsvd0:                  resw 1    ;Reservado
   .reg_esp0:               resd 1    ;Stack nivel 0 -esp
   .reg_ss0:                resw 1    ;Stack nivel 0 -ess
   .rsvd1:                  resw 1    ;Reservado
   .reg_esp1:               resd 1    ;No utilzado - Stack nivel 1 -esp
   .reg_ss1:                resw 1    ;No utilzado - Stack nivel 1 -ess
   .rsvd2:                  resw 1    ;Reservado
   .reg_esp2:               resd 1    ;No utilzado - Stack nivel 2 -esp
   .reg_ss2:                resw 1    ;No utilzado - Stack nivel 2 -ess
   .rsvd3:                  resw 1    ;Reservado
   .reg_cr3:                resd 1    ;Registro CR3
   .reg_eip:                resd 1    ;Registro EIP
   .reg_eflags:             resd 1    ;Registro EFlags
   .reg_eax:                resd 1    ;Registro EAX
   .reg_ecx:                resd 1    ;Registro ECX
   .reg_edx:                resd 1    ;Registro EDX
   .reg_ebx:                resd 1    ;Registro EBX
   .reg_esp:                resd 1    ;Registro ESP
   .reg_ebp:                resd 1    ;Registro EBP
   .reg_esi:                resd 1    ;Registro ESI
   .reg_edi:                resd 1    ;Registro EDI
   .reg_es:                 resw 1    ;Registro ES
   .rsvd4:                  resw 1    ;Reservado
   .reg_cs:                 resw 1    ;Registro CS
   .rsvd5:                  resw 1    ;Reservado
   .reg_ss:                 resw 1    ;Registro SS
   .rsvd6:                  resw 1    ;Reservado
   .reg_ds:                 resw 1    ;Registro DS
   .rsvd7:                  resw 1    ;Reservado
   .reg_fs:                 resw 1    ;Registro FS
   .rsvd8:                  resw 1    ;Reservado
   .reg_gs:                 resw 1    ;Registro GS
   .rsvd9:                  resw 1    ;Reservado
   .LTD_ss:                 resw 1    ;No utilizado - LDT Segment Selector
   .rsvd10:                 resw 1    ;Reservado
   .rsvd11:                 resw 1    ;Reservado
   .io_map_base_addr:       resw 1    ;No utilizado - I/O Map Base Address
endstruc

%define TAREA_0 0
%define TAREA_1 1
%define TAREA_2 2
%define TAREA_3 3
%define TAREA_4 4
