SECTION .bss nobits alloc noexec write

GLOBAL __tarea_prox
GLOBAL __tarea_actual
GLOBAL __timer_count_t1
GLOBAL __timer_count_t2
GLOBAL __timer_count_t3
GLOBAL __timer_count_t4
GLOBAL T1_timer_max
GLOBAL T2_timer_max
GLOBAL T3_timer_max
GLOBAL T4_timer_max
GLOBAL __last_SIMD

;Auxiliares del scheduler

__tarea_prox:               ;Guardo la próxima tarea a switchear
  resb 1

__tarea_actual:             ;Guardo la tarea actual que se está ejecutando
  resb 1

__timer_count_t1:           ;Contador de la Tarea 1
  resb 1
;Este está inicializado con un offset así no se me ejecuta al mismo tiempo que T1
;Idem T3 y T4
__timer_count_t2:           ;Contador de la Tarea 2
  resb 1

__timer_count_t3:           ;Contador de la Tarea 3
  resb 1

__timer_count_t4:           ;Contador de la Tarea 4
  resb 1

__last_SIMD:                ;Reservo para guardar cuál fue la última tarea que usó SIMD
  resb 1

;El timmer se dispara cada 10ms
;Tarea 1 se debe ejecutar cada 100ms, 10 veces la interrupción dle timmer tick
;Tarea 2 se debe ejecutar cada 200ms, 20 veces la interrupción del timmer tick
;Tarea 3 se dbee ejecutar cada 300ms, 30 veces la interrupción del timmer tick
;Tarea 4 se debe ejecutar cada 400ms, 40 veces la interrupción del timmer tick
;Dado que se deberían en un momento ejecutar al mismo tiempo
;Se le puso un offset a la Tarea2, Tarea3 y Tarea 4
T1_timer_max equ 0x0A       ;100 ms - Tarea 1
T2_timer_max equ 0x15       ;200 ms - Tarea 2
T3_timer_max equ 0x20       ;300 ms - Tarea 3
T4_timer_max equ 0x2B       ;400 ms - Tarea 4

;********** Tarea 1 **********

;************ Data ***********

SECTION .data_tarea1 nobits alloc noexec write

GLOBAL __tabla_digitos_t1

;Se reserva espacio de memoria dónde copiar la tabla de dígitos
__tabla_digitos_t1:
  resq 512
;Reservo una página (4K)

;************ BSS ************

SECTION .bss_tarea1 nobits alloc noexec write

GLOBAL enter_t1

;Se reserva espacio de memoria dónde guardar la suma de la tabla de dígitos
enter_t1:
  resq 1

;********** Tarea 2 **********

;************ Data ***********

SECTION .data_tarea2 nobits alloc noexec write

GLOBAL __tabla_digitos_t2

;Se reserva espacio de memoria dónde copiar la tabla de dígitos
__tabla_digitos_t2:
  resq 512
;Reservo una página (4K)

;************ BSS ************

SECTION .bss_tarea2 nobits alloc noexec write

GLOBAL enter_t2

;Se reserva espacio de memoria dónde guardar la suma de la tabla de dígitos
enter_t2:
  resq 1

;********** Tarea 3 **********

;************ Data ***********

SECTION .data_tarea3 nobits alloc noexec write

GLOBAL __tabla_digitos_t3

;Se reserva espacio de memoria dónde copiar la tabla de dígitos
__tabla_digitos_t3:
  resq 512
;Reservo una página (4K)

;************ BSS ************

SECTION .bss_tarea3 nobits alloc noexec write

GLOBAL enter_t3

;Se reserva espacio de memoria dónde guardar la suma de la tabla de dígitos
enter_t3:
  resq 1

;********** Tarea 4 **********

;************ Data ***********

SECTION .data_tarea4 nobits alloc noexec write

GLOBAL __tabla_digitos_t4

;Se reserva espacio de memoria dónde copiar la tabla de dígitos
__tabla_digitos_t4:
  resq 512
;Reservo una página (4K)

;************ BSS ************

SECTION .bss_tarea4 nobits alloc noexec write

GLOBAL enter_t4

;Se reserva espacio de memoria dónde guardar la suma de la tabla de dígitos
enter_t4:
  resq 1
