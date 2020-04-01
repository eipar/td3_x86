/**
	\file  init32.c
	\version 01.00
	\brief Definicion de funciones de inicializacion del procesador en 32b

	\author Christian Nigri <cnigri@utn.edu.ar>
	\date    18/04/2017
*/

#include "../inc/sys_types.h"
#include "../inc/defs_keyboard.h"

/***************************************************************************//**
*
* @fn         __fast_memcpy
*
* @brief      Esta funcion copia length double words desde dst a src.
*             No se raliza validacion de las regiones de memoria.
*             En caso de exito retorna EXITO o ERROR_DEFECTO en cualquier otra
*             circunstancia
*
* @param [in] src puntero tipo double word. Especifica la direccion de origen.
*
* @param [in] dst puntero tipo double word. Especifica la direccion de destino.
*
* @param [in] length tipo double word. Especifica el numero de double wors a copiar.
*
* @return     tipo byte indicando si falla o no.
*
******************************************************************************/
__attribute__(( section(".init32"))) byte __fast_memcpy(dword *dst, const dword *src, dword length)
{

   byte status = ERROR_DEFECTO;

   if(length > 0)
   {

      while(length)
      {
         length--;
         *dst++ = *src++;
      }
      status = EXITO;
   }

   return(status);
}

/* Hago un __fast_memcpy_ram debido a la funcionalidad de los system calls, que están en ram
   Y no puedo llamar a una función en rom */
__attribute__(( section(".funcion_ram"))) byte __fast_memcpy_ram(dword *dst, const dword *src, dword length)
{

   byte status = ERROR_DEFECTO;

   if(length > 0)
   {

      while(length)
      {
         length--;
         *dst++ = *src++;
      }
      status = EXITO;
   }

   return(status);
}

/* Función para leer del puerto */
__attribute__(( section(".funcion_ram"))) static inline byte inb(word port)
{
    byte ret;
    asm volatile ( "inb %1, %0": "=a"(ret): "Nd"(port) );
    return ret;
}

/* Funcion para copiar de a byte */
__attribute__(( section(".funcion_ram"))) byte __byte_memcpy(byte *dst, byte *src, dword length)
{

   byte status = ERROR_DEFECTO;

   if(length > 0)
   {

      while(length)
      {
         length--;
         *dst++ = *src++;
      }
      status = EXITO;
   }

   return(status);
}

/* Handler de Teclado */
__attribute__(( section(".funcion_ram"))) void __keyboard_int_handler (byte *dst,\
                                                                    byte *cant_ing, \
                                                                    byte *buf_circ, \
                                                                    byte *idx_buf)
//esto recibe donde lo quiero, donde esta el buffer y donde esta el indice del buffer
{
    byte status_key = 0x00;
    byte valid = 0x00;
    byte tecla = 0x00;
    qword * arr_64 = (qword *)(buf_circ+IDX_LIM); //lo quiero mas adelante, aunque sea un simple aux
    byte * buf_circ_acom = (byte *)(buf_circ+2*IDX_LIM);
    byte i = 0x00;
    qword aux_64 = 0x0;

        status_key = inb(0x64);
        if((status_key & 0x01)==0x01) //se apreto algo, no si se solto
        {
            tecla = inb(0x60);  //leemos el scan code
            valid = 0xFF;
            if(tecla == KEY_0) tecla = NUMBER_0;
            else if(tecla == KEY_1) tecla = NUMBER_1;
            else if(tecla == KEY_2) tecla = NUMBER_2;
            else if(tecla == KEY_3) tecla = NUMBER_3;
            else if(tecla == KEY_4) tecla = NUMBER_4;
            else if(tecla == KEY_5) tecla = NUMBER_5;
            else if(tecla == KEY_6) tecla = NUMBER_6;
            else if(tecla == KEY_7) tecla = NUMBER_7;
            else if(tecla == KEY_8) tecla = NUMBER_8;
            else if(tecla == KEY_9) tecla = NUMBER_9;
            else if(tecla == KEY_A) tecla = NUMBER_A;
            else if(tecla == KEY_B) tecla = NUMBER_B;
            else if(tecla == KEY_C) tecla = NUMBER_C;
            else if(tecla == KEY_D) tecla = NUMBER_D;
            else if(tecla == KEY_E) tecla = NUMBER_E;
            else if(tecla == KEY_F) tecla = NUMBER_F;
            else if(tecla == KEY_ENTER) tecla = ENTER;
            else valid = 0x00;
        }
        else
        {
            return ; //si fue un break code, me vuelvo, no hago nada
        }

        if (valid == 0xFF) //si se apreto uno valido
        {
            if (tecla == ENTER) //si lo valido fue un enter
            {
                //reacomodo el buffer, porque lo tengo al reves.
                for(i=0;i<(*idx_buf);i++)
                {
                    *(buf_circ_acom+(((*idx_buf)-1)-i)) = *(buf_circ+i);
                }
                for(i = 0;i<(*idx_buf);i++) //hacer el shift necesario para cada byte pasarlo a nibble. "compresor"
                {
                    (*arr_64)=(*arr_64) & ((~((qword)(0xF) << (4*i) )));//limpio el nibble correcto,porque sino la OR me mantiene lo anterior
                    (*arr_64)=(*arr_64) | ((qword )(*(buf_circ_acom+(i))) << (4*i) );
                }
                for(i = 0;i<4*(*idx_buf);i++) //me genero un monton de 1's, para llenar los nibbles presionados
                {
                    aux_64 = aux_64 | ((aux_64 << 1) + 0x1);
                }
                (*arr_64) = (*arr_64) & aux_64;
                __byte_memcpy((dst+8*(*cant_ing)), (byte *) arr_64, (IDX_LIM/2));//copio todo mi buffer circular a Datos
                if ((*cant_ing) == LIM_INGRESOS) (*cant_ing) = 0x00;
                (*cant_ing) = (*cant_ing) + 1;
                (*idx_buf) = 0x00;
            }
            else  //si es un numero
            {
                if ((*idx_buf) == IDX_LIM) (*idx_buf) = 0x00; //IDX_LIM tiene que ser 16, 0x10
                (*(buf_circ+(*idx_buf))) = tecla;
                (*idx_buf)++;
            }
        }//si no se apreto uno valido no hago nada, vuelvo
   return ;
}
