#include "../inc/sys_types.h"
#include "../inc/user_defines.h"

#define ERROR 0x00

//Tamaño de cada página (4K - 0x1000)
//Cantidad de Páginas ingresadas por el Page Fault
extern dword __PAGE_SIZE, __CANT_PAG;

//Dónde empieza cada árbol
extern dword __PT_START_T0, __PT_START_T1, __PT_START_T2, __PT_START_T3, __PT_START_T4;

//Physical Address
extern dword ___handler_phy, ___kernel_phy, \
        ___sys_table_phy, __digit_table_phy, \
        __data_phy, __stack_phy, \
        __t0_page_table_phy, __t2_page_table_phy, __t1_page_table_phy, \
        __t3_page_table_phy, __t4_page_table_phy, \
        __t0_text_phy, __t0_bss_phy, __t0_data_phy, \
        __t0_stack_phy, __t0_tss_phy, \
        __t1_text_phy, __t1_bss_phy, __t1_data_phy, \
        __t1_stack_phy, __t1_tss_phy, \
        __t2_text_phy, __t2_bss_phy, __t2_data_phy, \
        __t2_stack_phy, __t2_tss_phy, \
        __t3_text_phy, __t3_bss_phy, __t3_data_phy, \
        __t3_stack_phy, __t3_tss_phy, \
        __t4_text_phy, __t4_bss_phy, __t4_data_phy, \
        __t4_stack_phy, __t4_tss_phy, \
        ___syscall_phy ;

//Linear Address
extern dword ___handler_dst, ___kernel_dst, \
        ___sys_table_dst, __digit_table_dst, \
        __data_dst, __stack_dst, \
        __t0_page_table_dst, __t2_page_table_dst, __t1_page_table_dst, \
        __t3_page_table_dst, __t4_page_table_dst, \
        __t0_text_dst, __t0_bss_dst, __t0_data_dst, \
        __t0_stack_dst, __t0_tss_dst, \
        __t1_text_dst, __t1_bss_dst, __t1_data_dst, \
        __t1_stack_dst, __t1_tss_dst, \
        __t2_text_dst, __t2_bss_dst, __t2_data_dst, \
        __t2_stack_dst, __t2_tss_dst, \
        __t3_text_dst, __t3_bss_dst, __t3_data_dst, \
        __t3_stack_dst, __t3_tss_dst, \
        __t4_text_dst, __t4_bss_dst, __t4_data_dst, \
        __t4_stack_dst, __t4_tss_dst, \
        ___syscall_dst;

//Sizes
extern dword ___handler_size, ___kernel_size, \
        ___sys_table_size, __digit_table_size, \
        __data_size, __stack_size, \
        __t0_page_table_size, __t2_page_table_size, __t1_page_table_size, \
        __t3_page_table_size, __t4_page_table_size, \
        __t0_text_size, __t0_bss_size, __t0_data_size, \
        __t0_stack_size, __t0_tss_size, \
        __t1_text_size, __t1_bss_size, __t1_data_size, \
        __t1_stack_size, __t1_tss_size, \
        __t2_text_size, __t2_bss_size, __t2_data_size, \
        __t2_stack_size, __t2_tss_size, \
        __t3_text_size, __t3_bss_size, __t3_data_size, \
        __t3_stack_size, __t3_tss_size, \
        __t4_text_size, __t4_bss_size, __t4_data_size, \
        __t4_stack_size, __t4_tss_size, \
        ___syscall_size;

/***************************************************************************//**
*
* @fn         __set_ptree_entry
*
* @brief      Esta funcion inicializa las entradas del arbol de paginacion sin
*             PAE para la direccion lineal address_lin, asociada con la
*             direccion fisica address_phy, correspondientes a la base del arbol
*             de paginacion ptree_base, con los atributos page_attr.
*             En caso de exito retorna EXITO o ERROR_DEFECTO en cualquier otra
*             circunstancia
*
* @param [in] ptree_size tipo ptree_32_psize_t. Especifica el tipo de pagina
*              correspondiente a un arbol de paginacion de 32b.
*
* @param [in] ptree_base tipo double word. Especifica la direccion base del
*              arbol de paginacion.
*
* @param [in] addr_phy tipo double word. Especifica la direccion fisica de la
*             pagina.
*
* @param [in] addr_lin tipo double word. Especifica la direccion lineal de la
*             pagina.
*
* @param [in] dir_attr tipo word. Especifica los atributos del directorio de paginas
*
* @param [in] page_attr tipo word. Especifica los atributos de las entradas
*             correspondientes a la nueva pagina.
*
* @return     tipo byte indicando si falla o no.
*
******************************************************************************
*  Paginacion sin PAE
*
*  +-----------------+  ptree_base
*  |PDe0             |
*  +-----------------+  Solo una tabla de directorios de 1024 entredas
de 4B c/u
*  |PDe1             |  Indice de la tabla ptree_pd
*  +-----------------+  Entrada de la tabla ptree_pde
*  |...             |
*  +-----------------+
*  |PDe1023          |
*  +-----------------+  ptree_base+4kB+0*4kB
*  |PTe0.0           |
*  +-----------------+
*  |PTe0.1           |
*  +-----------------+
*  |...              |
*  +-----------------+
*  |PTe0.1023        |
*  +-----------------+  ptree_base+4kB+x*4kB
*  |PTex.0           |
*  +-----------------+  1024 tablas de paginas de 1024 entredas de 4B
c/u
*  |PTex.1           |  Indice de la tabla ptree_pt
*  +-----------------+  Entrada de la tabla ptree_pte
*  |...              |
*  +-----------------+
*  |PTex.1023        |
*  +-----------------+  ptree_base+4kB+1023*4kB
*  |PTe1023.0        |
*  +-----------------+
*  |PDe1023.1        |
*  +-----------------+
*  |...              |
*  +-----------------+
*  |PDe1023.1023     |
*  +-----------------+
*
******************************************************************************/
__attribute__(( section(".funcion_ram"))) byte __set_ptree_entry(ptree_32_psize_t page_size, dword const ptree_base, \
                                                            dword addr_phy, dword addr_lin, word dir_atrr, word page_attr){

    byte status = ERROR_DEFECTO;

    //Obtengo el offset del Directorio de Tabla de Páginas y de la Tabla de Páginas de la Dirr Lineal
    dword p_dir = ((addr_lin & MASK_4K_PAGE_DIR) >> MASK_PD)*sizeof(dword);           //Page Directory
    dword p_table = ((addr_lin & MASK_4K_PAGE_TABLE) >> MASK_PT)*sizeof(dword);       //Page Table
    //Enmascaro el CR3
    dword p_base_alig = (ptree_base & MASK_BASE);

    dword * ptr_pde = 0x0;          //Puntero al Page Directory Entry
    dword * ptr_pte = 0x0;          //Puntero al Page Table Entry

    //Al CR3 le sumo el offset y obtengo la dirección dónde está ubicada la entrada de la PD
    //Que su contenido va a tener la dirección de la Tabla de Páginas buscada
    ptr_pde = (dword*)(p_base_alig + p_dir);  //Apuntamos a la Page Directory

    if((*ptr_pde) == 0x0){
        //No tengo ninguna entrada cargada
        (*ptr_pde) = (p_base_alig + CONST_4K + (p_dir*CONST_4K) +  (dword)dir_atrr);  //Atributos de Page Directory Entry
        //Le sumo 4096 porque está 4K más adelante de la base
        //El tercer termino es para ir a la entrada siguiente a 4096 de distancia
    }

    //Obtengo la dirección de la tabla de páginas con el contenido de la PDEntry
    //Le sumo el offset y tengo el Page Table Entry
    //Su contenido va a apuntar a la página que busco
    ptr_pte = (dword*)(((*ptr_pde) & MASK_BASE) + p_table);     //Apuntamos a la Page Table
    (*ptr_pte) = ((addr_phy & MASK_BASE) + page_attr);          //Atributos de Page Table Entry
    //A la Entrada de PT le tengo que poner los atributos de la página
    status = EXITO;

    return(status);

}

/****** Inicialización de Paginación ******/
//Se pagina cada una de las secciones según su árbol de paginación
//Con los atributos correspondientes

__attribute__(( section(".init32"))) void page_init (void){

  dword index = 0, aux = 0;

  /************ Paginación a nivel kernel ************/

  dword kernel_addr_phy[] = {(dword)&___handler_phy, (dword)&___kernel_phy, \
                            (dword)&___sys_table_phy, (dword)&__digit_table_phy, \
                            (dword)&__data_phy, (dword)&__stack_phy, \
                            (dword)&__t0_page_table_phy, (dword)&__t2_page_table_phy, \
                            (dword)&__t1_page_table_phy, (dword)&__t3_page_table_phy, \
                            (dword)&__t4_page_table_phy};

  dword kernel_addr_lin[] = {(dword)&___handler_dst, (dword)&___kernel_dst, \
                            (dword)&___sys_table_dst, (dword)&__digit_table_dst, \
                            (dword)&__data_dst, (dword)&__stack_dst, \
                            (dword)&__t0_page_table_dst, (dword)&__t2_page_table_dst, \
                            (dword)&__t1_page_table_dst, (dword)&__t3_page_table_dst, \
                            (dword)&__t4_page_table_dst};

  dword kernel_size[]     = {(dword)&___handler_size, (dword)&___kernel_size, \
                            (dword)&___sys_table_size, (dword)&__digit_table_size, \
                            (dword)&__data_size, (dword)&__stack_size, \
                            (dword)&__t0_page_table_size, (dword)&__t2_page_table_size, \
                            (dword)&__t1_page_table_size, (dword)&__t3_page_table_size, \
                            (dword)&__t4_page_table_size};

  /* Handler, Kernel y Systables tienen permiso de supervisor pero sólo Readable
     Digit table, Data, Stack, y los Árboles de paginación tienen permiso de supervisor pero Writable */
  word kernel_pte_attr[]  = {PTE_ATRR_S_RO, PTE_ATRR_S_RO, \
                            PTE_ATRR_S_RO, PTE_ATRR_S_RW, \
                            PTE_ATRR_S_RW, PTE_ATRR_S_RW, \
                            PTE_ATRR_S_RW, PTE_ATRR_S_RW, \
                            PTE_ATRR_S_RW, PTE_ATRR_S_RW, \
                            PTE_ATRR_S_RW};

  for(index = 0; index < sizeof(kernel_addr_lin)/4; index++){      //Por cada dirección lineal cargada en el vector
    while(kernel_size[index]){
      //Árbol Tarea 0
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T0, \
                        (kernel_addr_phy[index] + ((dword)&__PAGE_SIZE*aux)), \
                        (kernel_addr_lin[index] + ((dword)&__PAGE_SIZE*aux)), \
                        PDE_ATRR_U, kernel_pte_attr[index]);
      //Árbol Tarea 1
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T1, \
                        (kernel_addr_phy[index] + ((dword)&__PAGE_SIZE*aux)), \
                        (kernel_addr_lin[index] + ((dword)&__PAGE_SIZE*aux)), \
                        PDE_ATRR_U, kernel_pte_attr[index]);
      //Árbol Tarea 2
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T2, \
                        (kernel_addr_phy[index] + ((dword)&__PAGE_SIZE*aux)), \
                        (kernel_addr_lin[index] + ((dword)&__PAGE_SIZE*aux)), \
                        PDE_ATRR_U, kernel_pte_attr[index]);

      //Árbol Tarea 3
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T3, \
                        (kernel_addr_phy[index] + ((dword)&__PAGE_SIZE*aux)), \
                        (kernel_addr_lin[index] + ((dword)&__PAGE_SIZE*aux)), \
                        PDE_ATRR_U, kernel_pte_attr[index]);

     //Árbol Tarea 4
     __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T4, \
                       (kernel_addr_phy[index] + ((dword)&__PAGE_SIZE*aux)), \
                       (kernel_addr_lin[index] + ((dword)&__PAGE_SIZE*aux)), \
                       PDE_ATRR_U, kernel_pte_attr[index]);

      if(kernel_size[index] > (dword)&__PAGE_SIZE){   //La página ocupa más de 4K, necesito otra
        kernel_size[index] -= (dword)&__PAGE_SIZE;
        aux++;
      }else{
        kernel_size[index] = 0;
        aux = 0;
      }
    }
  }

  //Limpio auxiliares por las dudas
  index = 0;
  aux = 0;

  /************ Paginación de page tables ************/

  for(index = 1; index < 129; index++){
    //Page Table - Tarea 0
    __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T0, \
                      ((dword)&__PT_START_T0 + (index * 0x1000)), \
                      ((dword)&__PT_START_T0 + (index * 0x1000)), \
                      PDE_ATRR_U, PTE_ATRR_S_RO);
    //Page Table - Tarea 1
    __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T1, \
                      ((dword)&__PT_START_T1 + (index * 0x1000)), \
                      ((dword)&__PT_START_T1 + (index * 0x1000)), \
                      PDE_ATRR_U, PTE_ATRR_S_RO);
    //Page Table - Tarea 2
    __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T2, \
                      ((dword)&__PT_START_T2 + (index * 0x1000)), \
                      ((dword)&__PT_START_T2 + (index * 0x1000)), \
                      PDE_ATRR_U, PTE_ATRR_S_RO);

    //Page Table - Tarea 3
    __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T3, \
                      ((dword)&__PT_START_T3 + (index * 0x1000)), \
                      ((dword)&__PT_START_T3 + (index * 0x1000)), \
                      PDE_ATRR_U, PTE_ATRR_S_RO);

    //Page Table - Tarea 2
    __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T4, \
                      ((dword)&__PT_START_T4 + (index * 0x1000)), \
                      ((dword)&__PT_START_T4 + (index * 0x1000)), \
                      PDE_ATRR_U, PTE_ATRR_S_RO);

  }

  //Limpio auxiliares por las dudas
  index = 0;
  aux = 0;

  /********* Paginación de Tarea 0 - Usuario *********/

  dword t0_addr_phy[] = {(dword)&__t0_text_phy, (dword)&__t0_bss_phy, \
                        (dword)&__t0_data_phy, (dword)&__t0_stack_phy, \
                        (dword)&__t0_tss_phy, (dword)&___syscall_phy};

  dword t0_addr_lin[] = {(dword)&__t0_text_dst, (dword)&__t0_bss_dst, \
                        (dword)&__t0_data_dst, (dword)&__t0_stack_dst, \
                        (dword)&__t0_tss_dst, (dword)&___syscall_dst};

  word to_attr[]      = {PTE_ATRR_S_RO, PTE_ATRR_S_RW, \
                        PTE_ATRR_S_RW, PTE_ATRR_S_RW, \
                        PTE_ATRR_S_RW, PTE_ATRR_S_RO};

  for(index = 0; index < 6; index++){
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T0, \
                        (dword)t0_addr_phy[index], \
                        (dword)t0_addr_lin[index], \
                        PDE_ATRR_U, to_attr[index]);
  }

  /********* Paginación de Tarea 1 - Usuario *********/

  dword t1_addr_phy[] = {(dword)&__t1_text_phy, (dword)&__t1_bss_phy, \
                        (dword)&__t1_data_phy, (dword)&__t1_stack_phy, \
                        (dword)&__t1_tss_phy, (dword)&___syscall_phy};

  dword t1_addr_lin[] = {(dword)&__t1_text_dst, (dword)&__t1_bss_dst, \
                        (dword)&__t1_data_dst, (dword)&__t1_stack_dst, \
                        (dword)&__t1_tss_dst, (dword)&___syscall_dst};

  word t1_attr[]      = {PTE_ATRR_U_RO, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RO};

  for(index = 0; index < 6; index++){
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T1, \
                        (dword)t1_addr_phy[index], \
                        (dword)t1_addr_lin[index], \
                        PDE_ATRR_U, t1_attr[index]);
  }

  /********* Paginación de Tarea 2 - Usuario *********/

  dword t2_addr_phy[] = {(dword)&__t2_text_phy, (dword)&__t2_bss_phy, \
                        (dword)&__t2_data_phy, (dword)&__t2_stack_phy, \
                        (dword)&__t2_tss_phy, (dword)&___syscall_phy};

  dword t2_addr_lin[] = {(dword)&__t2_text_dst, (dword)&__t2_bss_dst, \
                        (dword)&__t2_data_dst, (dword)&__t2_stack_dst, \
                        (dword)&__t2_tss_dst, (dword)&___syscall_dst};

  word t2_attr[]      = {PTE_ATRR_U_RO, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RO};

  for(index = 0; index < 6; index++){
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T2, \
                        (dword)t2_addr_phy[index], \
                        (dword)t2_addr_lin[index], \
                        PDE_ATRR_U, t2_attr[index]);
  }

  /********* Paginación de Tarea 3 - Usuario *********/

  dword t3_addr_phy[] = {(dword)&__t3_text_phy, (dword)&__t3_bss_phy, \
                        (dword)&__t3_data_phy, (dword)&__t3_stack_phy, \
                        (dword)&__t3_tss_phy, (dword)&___syscall_phy};

  dword t3_addr_lin[] = {(dword)&__t3_text_dst, (dword)&__t3_bss_dst, \
                        (dword)&__t3_data_dst, (dword)&__t3_stack_dst, \
                        (dword)&__t3_tss_dst, (dword)&___syscall_dst};

  word t3_attr[]      = {PTE_ATRR_U_RO, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RO};

  for(index = 0; index < 6; index++){
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T3, \
                        (dword)t3_addr_phy[index], \
                        (dword)t3_addr_lin[index], \
                        PDE_ATRR_U, t3_attr[index]);
  }

  /********* Paginación de Tarea 4 - Usuario *********/

  dword t4_addr_phy[] = {(dword)&__t4_text_phy, (dword)&__t4_bss_phy, \
                        (dword)&__t4_data_phy, (dword)&__t4_stack_phy, \
                        (dword)&__t4_tss_phy, (dword)&___syscall_phy};

  dword t4_addr_lin[] = {(dword)&__t4_text_dst, (dword)&__t4_bss_dst, \
                        (dword)&__t4_data_dst, (dword)&__t4_stack_dst, \
                        (dword)&__t4_tss_dst, (dword)&___syscall_dst};

  word t4_attr[]      = {PTE_ATRR_U_RO, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RW, \
                        PTE_ATRR_U_RW, PTE_ATRR_U_RO};

  for(index = 0; index < 6; index++){
      __set_ptree_entry((dword)&__PAGE_SIZE, (dword)&__PT_START_T4, \
                        (dword)t4_addr_phy[index], \
                        (dword)t4_addr_lin[index], \
                        PDE_ATRR_U, t4_attr[index]);
  }

}

/****** Page Fault Handler ******/
//Esta comentado momentaneamente, pero su funcionamiento esta implementado y probado

__attribute__(( section(".handlers"))) void __pagefault_handler (dword cr3, dword cr2, dword error_code){

  /*if((error_code & MASK_ERR_NOT_PRESENT) == ERR_NOT_PRESENT){
    //No hay una página
    //Asigno a partir de la dirección fisica del enunciado
    __set_ptree_entry((dword)&__PAGE_SIZE, cr3, (DIRR_PHY_NOT_PRESENT + ((dword)&__PAGE_SIZE*(dword)&__CANT_PAG)), \
                      cr2, PDE_ATRR_U, PTE_ATRR_U_RW);
    __CANT_PAG++;
  }*/

  //asm("xchg %%bx,%%bx"::);
}

/***** Chequeo de paginación ****/
//Función utilizada en la función llamado a syscall td3_read
//Dado que debe chequear que la dirección de la tarea dónde se quiere copiar la tabla de digitos esté paginada

__attribute__(( section(".funcion_ram"))) byte __check_paged (dword ptree_base, dword addr_lin, \
                                                              word dir_atrr, word page_attr){

  dword offset_DTP = 0, offset_TP = 0;
  dword *entry_DTP = 0, *pagetable = 0, *entry_PT = 0;
  dword *aux_pt = 0;
  word aux_pag_atrr = 0;

  /* La idea de esta función es apuntar al PDE y TPE y verificar que haya algo escrito
     Como no tenemos la dirección física de la página no puedo comprobar que tenga la página correcta
     Pero si que la PD y TP tengan una entrada con los atributos correctos */

  //Obtengo el offset de la PT, para obtener el entry dps
  offset_DTP = ((addr_lin & MASK_4K_PAGE_DIR) >> MASK_PD)*sizeof(dword);

  //Obtengo el offset de la TP, para obtener su entry dps
  offset_TP = ((addr_lin & MASK_4K_PAGE_TABLE) >> MASK_PT)*sizeof(dword);

  //Ahora tengo que obtener la PDE
  //Con esto, apunto al entry
  entry_DTP = (dword*)((ptree_base & MASK_BASE) + offset_DTP);

  //El contenido de entry_DTP me tiene que coincidir con la dirección de TP que obtengo de la dirr lineal

  //Apunto al TP
  pagetable = (dword*)(ptree_base + (CONST_4K_HEX*(offset_DTP + 1)));

  //Le agrego los atributos para simular la entrada que deberia tener la PD
  //Para eso tengo que correr pagetable 12 bits para que entren los atributos
  //Andeo los atributos porque dir_atrr es un word y los atributos que necesito son solo 3 nibbles
  //Esto es para que no sume "basura"
  aux_pt = (dword*)(((dword)pagetable) + (dir_atrr & 0x00FF));

  //Le enmarcaro el bit de accedido
  //Porque capaz no se usó esa página todavía
  if((dword*)((*entry_DTP) & 0xFFFFFFDF) != aux_pt){
    //No apunta a la tabla de páginas que debería apuntar
    //Hay un error de paginación
    return ERROR;
  }

  //Ahora toca verificar el contenido de la tabla de páginas
  //pagetable apunte ahi
  //Le tengo que sumar el offset para tener la entry
  entry_PT = (dword*)(((dword)(pagetable)) + offset_TP);
  //Enmascaro y me quedo sólo con los atributos de la Page Table
  //Otra forma de verificar que esté todo bien a falta de la dirección física
  //Verifico que tenga los atributos correctos
  aux_pag_atrr = (word)((*entry_PT) & 0x00000007);

  if(((*entry_PT) != 0) && (aux_pag_atrr != page_attr) ){
    //Si no se cumple la 1er condición -> La PTE no tiene entrada de una página
    //Si no se cumple la 2da condición -> La PTE tiene una entrada, pero con diferentes atributos de página
    //No es válida
    return ERROR;
  }

  return EXITO;

}
