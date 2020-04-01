SECTION  .kernel32 progbits

GLOBAL main

EXTERN __PT_START_T0
EXTERN __PT_START_T1
EXTERN __PT_START_T2
EXTERN __STACK_T0_END

EXTERN TSS

EXTERN tarea0

USE32

main:
  ;Chequeo si el CPU tiene SSE/SMID
  cpuid
  test edx, 1<<25
  jz no_SSE                       ;El CPU no soporta SSE

  ;Soporta SSE, entonces tengo que activar bits en CR0 y CR4
  ;En CR0, tengo los bits EM, MP y TS
  ;EM -> Emulation (bit 2). En 0, hay un x87 FPU presente. Si está en 1, salta Opcode Exception
  ;MP -> Monitor (bit 1). Se pueden generar #NM si el TS esta seteado
  ;TS -> Task Switched (bit 3). Se setea en cada task switch
  ;y se utiliza para guardar los registros mmx sólo cuando se switchea
  mov eax, cr0
  and eax, ~(1<<2)                ;Limpio el bit CR0.EM
  or eax, (1<<1)                  ;Seteo el bit CR0.MP
  and eax, ~(1<<3)                ;Limpio el bit CR0.TS
  ;Vuelvo a cargar el CR0 con esto nuevo
  mov cr0, eax

  ;En CR4, tengo los bits OSFXSR y OSXMMEXCPT
  ;OSFXSR     -> Operating System Support for fxsave and fxstor instructions (bit 9)
  ;su nombre lo dice todo
  ;OSXMMEXCPT -> Operating System Support for unmasked SIMD floating-point exceptions (bit 10)
  ;idem
  mov eax, cr4
  or ax, (3<<9)                   ;Seteo estos dos bits
  ;Vuelvo a cargar el CR4
  mov cr4, eax

  xor eax, eax                    ;Limpio eax por las dudas

no_SSE:
  ;Cargo el CR3 de la Tarea 0
  ;Es la Tarea a la que voy a entrar por default
  ;Voy a estar en el árbol de paginación de la Tarea 0
  mov eax, __PT_START_T0
  mov cr3, eax

  ;Habilitación de paginación
  mov eax,cr0                     ;Pongo en 1 el bit 31 (PG) de CR0
  or eax, 0x80000000              ;Para activar paginación
  mov cr0,eax

  mov esp, __STACK_T0_END - 0x04  ;Apunto al stack de la Tarea 0

  mov ax, TSS                     ;Cargo la TSS
  ltr ax

  sti                             ;Habilito las interrupciones

main_init:
  call tarea0 + 0x03              ;Voy a la Tarea0 dónde sólo halteo
  jmp main_init
