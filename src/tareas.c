#include "../inc/sys_types.h"

#define num_bytes 20

extern qword __tabla_digitos_t1, enter_t1;
extern qword __tabla_digitos_t2, enter_t2;
extern qword __tabla_digitos_t3, enter_t3;
extern qword __tabla_digitos_t4, enter_t4;

qword t1_res __attribute__((section(".bss_tarea1"))) __attribute__((aligned(16)));
qword t2_res __attribute__((section(".bss_tarea2"))) __attribute__((aligned(16)));
qword t3_res __attribute__((section(".bss_tarea3"))) __attribute__((aligned(16)));
qword t4_res __attribute__((section(".bss_tarea4"))) __attribute__((aligned(16)));

/****************************** Tarea 0 ******************************/
/********************* Tarea Idle -> sólo haltea *********************/
/*********************************************************************/

__attribute__(( section(".txt_tarea0"))) void tarea0 (void){

  while(1){
    asm("hlt");
  }

}

/****************************** Tarea 1 ******************************/
/***** Suma todos los números almacenados en la tabla de dígitos *****/
/************ Suma aritmética por desborde en tamaño byte ************/
/*********************************************************************/

__attribute__(( section(".txt_tarea1"))) void tarea1 (void){

  byte i;
  qword * pTablaDigitos_t1 = (qword *)&__tabla_digitos_t1;

  while(1){
    //Syscall para saber cuántas entradas se ingresaron
    td3_enter(&enter_t1);


    if(enter_t1 > 1){
      //Llamo a la función que me permite leer la tabla de dígitos y copiarla a una sección
      //de memoria dónde puede acceder la tarea
      td3_read(&(__tabla_digitos_t1), (enter_t1*8));

      //Sumo todos los digitos en la tabla
      for(i=0; i<enter_t1; i=i+2){

        //Llamo a una función en assembler que suma SIMD
        __suma_desb_dword((pTablaDigitos_t1+i), &t1_res);

      }
      //asm("xchg %%bx,%%bx"::);
    }

    //asm("xchg %%bx,%%bx"::);
    //Una vez que termino, halteo
    td3_halt();
  }

}

/****************************** Tarea 2 ******************************/
/***** Suma todos los números almacenados en la tabla de dígitos *****/
/************ Suma aritmética por desborde en tamaño dword ***********/
/*********************************************************************/

__attribute__(( section(".txt_tarea2"))) void tarea2 (void){

  byte i;
  qword * pTablaDigitos_t2 = (qword *)&__tabla_digitos_t2;

  while(1){
    //Syscall para saber cuántas entradas se ingresaron
    td3_enter(&enter_t2);

    if(enter_t2 > 1){
      //Llamo a la función que me permite leer la tabla de dígitos y copiarla a una sección
      //de memoria dónde puede acceder la tarea
      td3_read(&(__tabla_digitos_t2), (enter_t2*8));

      //Sumo todos los digitos en la tabla
      for(i=0; i<enter_t2; i=i+2){

        //Llamo a una función en assembler
        __suma_desb_byte((pTablaDigitos_t2+i), &t2_res);

      }
      //asm("xchg %%bx,%%bx"::);
    }

    //asm("xchg %%bx,%%bx"::);
    //Una vez que termino, halteo
    td3_halt();
  }

}

/****************************** Tarea 3 ******************************/
/***** Suma todos los números almacenados en la tabla de dígitos *****/
/****************** Suma en formato saturado signado *****************/
/*********************************************************************/

__attribute__(( section(".txt_tarea3"))) void tarea3 (void){

  byte i;
  qword * pTablaDigitos_t3 = (qword *)&__tabla_digitos_t3;

  while(1){
    //Syscall para saber cuántas entradas se ingresaron
    td3_enter(&enter_t3);

    if(enter_t3 > 1){
      //Llamo a la función que me permite leer la tabla de dígitos y copiarla a una sección
      //de memoria dónde puede acceder la tarea
      td3_read(&(__tabla_digitos_t3), (enter_t3*8));

      //Sumo todos los digitos en la tabla
      for(i=0; i<enter_t3; i=i+2){

        //Llamo a una función en assembler
        __suma_sat_signed_byte((pTablaDigitos_t3+i), &t3_res);

      }

    }

    //asm("xchg %%bx,%%bx"::);
    //Una vez que termino, halteo
    td3_halt();
  }

}

/****************************** Tarea 4 ******************************/
/***** Suma todos los números almacenados en la tabla de dígitos *****/
/*************** Suma en formato saturado no signado *****************/
/*********************************************************************/

__attribute__(( section(".txt_tarea4"))) void tarea4 (void){

  byte i;
  qword * pTablaDigitos_t4 = (qword *)&__tabla_digitos_t4;

  while(1){
    //Syscall para saber cuántas entradas se ingresaron
    td3_enter(&enter_t4);

    if(enter_t4 > 1){
      //Llamo a la función que me permite leer la tabla de dígitos y copiarla a una sección
      //de memoria dónde puede acceder la tarea
      td3_read(&(__tabla_digitos_t4), (enter_t4*8));

      //Sumo todos los digitos en la tabla
      for(i=0; i<enter_t4; i=i+2){

        //Llamo a una función en assembler
        __suma_sat_unsigned_byte((pTablaDigitos_t4+i), &t4_res);

      }
      
    }

    //asm("xchg %%bx,%%bx"::);
    //Una vez que termino, halteo
    td3_halt();
  }

}
