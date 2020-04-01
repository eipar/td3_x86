SECTION .funcion_ram progbits

GLOBAL __suma_desb_dword
GLOBAL __suma_desb_byte
GLOBAL __suma_sat_signed_byte
GLOBAL __suma_sat_unsigned_byte

GLOBAL keyboard_push
GLOBAL keyboard_pop

USE32

;*********************************************************************************************
;*************************************Keyboard Push y Pop*************************************
;*********************************************************************************************

USE32

KEYB_IN     db 0            ;Indices de la cola circular
KEYB_OUT    db 0
KEYB_BUFF   times 16 db 0

keyboard_push:
    pushad

    xor ebx, ebx
    mov bl, [KEYB_IN]       ;Cargo posición de carga
    mov [KEYB_BUFF+ebx], al ;Guardo la tecla presionada
    inc bl                  ;Incremento el índice de ingreso
    mov [KEYB_IN], bl

    popad
    ret

keyboard_pop:
    push ebp
    mov ebp, esp
    add ebp, 8              ;Apunto a donde esta la dirección del 1er argumento
    mov ebp, [ebp]          ;Es una dirección así que apunto ebp a esta

    push ebx
    mov eax, 0xFF           ;Cargo el error return
    mov ebx, 0

    mov bl, [KEYB_OUT]
    cmp bl, [KEYB_IN]       ;Comparo los dos indices: Son distintos -> hay dato nuevo
    mov eax, 1              ;Retorno NOK
    je end_pop

    mov al, [KEYB_BUFF+ebx] ;Leo el dato
    mov [ebp], al           ;Lo guardo en el puntero pasado en el argumento
    mov eax, 0              ;Retorno OK
    inc bl                  ;Aumento el índice de salida
    mov [KEYB_OUT], bl

    end_pop:
        pop ebx
        pop ebp
        ret

;*********************************************************************************************
;****************************************Sumas en SIMD****************************************
;*********************************************************************************************

;Recibe lo que hay que sumar
;xmm0 -> voy a copiarle una quardword de la que tengo que sumar
;xmm1 -> voy a copairle las dos quadword y me quedo con la superior (primeros 64bits)
;xmm2 -> le copio la suma total que me va quedando, luego lo copio a la bss de la tarea llamante

__suma_desb_dword:
  ;xchg bx, bx
  push eax
  push ebx

  xor eax, eax

  mov ebx, [esp+0x0C]           ;Agarro lo pasado por argumento, que es lo que quiero sumar
  mov eax, [esp+0x10]

  ;Obtengo el 1er quadword a sumar
  pxor xmm0, xmm0               ;Limpio el registro de suma
  movq xmm0, [ebx]              ;Lo paso a un registro xmm

  ;Obtengo el 2do quadword a sumar
  pxor xmm1, xmm1               ;Limpio el registro de suma
  movdqa xmm1, [ebx]            ;Le paso los dos quad
  psrldq xmm1, 8                ;Acá tengo el segundo quad

  paddd xmm1, xmm0              ;Sumo los quad entre sí
  paddd xmm2, xmm1              ;Lo sumo a la suma anterior

  ;La cargo en la dirección enviada por la tarea
  movq [eax], xmm2

  pop ebx
  pop eax
  ret

;Recibe lo que hay que sumar
;xmm0 -> voy a copiarle una quardword de la que tengo que sumar
;xmm1 -> voy a copairle las dos quadword y me quedo con la superior (primeros 64bits)
;xmm2 -> le copio la suma total que me va quedando, luego lo copio a la bss de la tarea llamante
__suma_desb_byte:
  ;xchg bx, bx
  push eax
  push ebx

  xor eax, eax

  mov ebx, [esp+0x0C]           ;Agarro lo pasado por argumento, que es lo que quiero sumar
  mov eax, [esp+0x10]

  ;Obtengo el 1er quadword a sumar
  pxor xmm0, xmm0               ;Limpio el registro de suma
  movq xmm0, [ebx]              ;Lo paso a un registro xmm

  ;Obtengo el 2do quadword a sumar
  pxor xmm1, xmm1               ;Limpio el registro de suma
  movdqa xmm1, [ebx]            ;Le paso los dos quad
  psrldq xmm1, 8                ;Acá tengo el segundo quad

  paddb xmm1, xmm0              ;Sumo los quad entre sí
  paddb xmm2, xmm1              ;Lo sumo a la suma anterior

  ;Devuelvo la suma total por eax
  movq [eax], xmm2

  pop ebx
  pop eax
  ret

;Recibe lo que hay que sumar
;xmm0 -> voy a copiarle una quardword de la que tengo que sumar
;xmm1 -> voy a copairle las dos quadword y me quedo con la superior (primeros 64bits)
;xmm2 -> le copio la suma total que me va quedando, luego lo copio a la bss de la tarea llamante
__suma_sat_signed_byte:
  ;xchg bx, bx
  push eax
  push ebx

  xor eax, eax

  mov ebx, [esp+0x0C]           ;Agarro lo pasado por argumento, que es lo que quiero sumar
  mov eax, [esp+0x10]

  ;Obtengo el 1er quadword a sumar
  pxor xmm0, xmm0               ;Limpio el registro de suma
  movq xmm0, [ebx]              ;Lo paso a un registro xmm

  ;Obtengo el 2do quadword a sumar
  pxor xmm1, xmm1               ;Limpio el registro de suma
  movdqa xmm1, [ebx]            ;Le paso los dos quad
  psrldq xmm1, 8                ;Acá tengo el segundo quad

  paddsb xmm1, xmm0              ;Sumo los quad entre sí
  paddsb xmm2, xmm1              ;Lo sumo a la suma anterior

  ;Devuelvo la suma total por eax
  movq [eax], xmm2

  pop ebx
  pop eax
  ret

;Recibe lo que hay que sumar
;xmm0 -> voy a copiarle una quardword de la que tengo que sumar
;xmm1 -> voy a copairle las dos quadword y me quedo con la superior (primeros 64bits)
;xmm2 -> le copio la suma total que me va quedando, luego lo copio a la bss de la tarea llamante
__suma_sat_unsigned_byte:
  ;xchg bx, bx
  push eax
  push ebx

  xor eax, eax

  mov ebx, [esp+0x0C]           ;Agarro lo pasado por argumento, que es lo que quiero sumar
  mov eax, [esp+0x10]

  ;Obtengo el 1er quadword a sumar
  pxor xmm0, xmm0               ;Limpio el registro de suma
  movq xmm0, [ebx]              ;Lo paso a un registro xmm

  ;Obtengo el 2do quadword a sumar
  pxor xmm1, xmm1               ;Limpio el registro de suma
  movdqa xmm1, [ebx]            ;Le paso los dos quad
  psrldq xmm1, 8                ;Acá tengo el segundo quad

  paddusb xmm1, xmm0             ;Sumo los quad entre sí
  paddusb xmm2, xmm1             ;Lo sumo a la suma anterior

  ;Devuelvo la suma total por eax
  movq [eax], xmm2

  pop ebx
  pop eax
  ret
