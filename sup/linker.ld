/********************* Stacks MP y MR *********************/
/* Stack de MP */
__STACK_START_32 = ORIGIN(stack);
__STACK_END_32 = ORIGIN(stack) + LENGTH(stack);
__STACK_SIZE_32 = LENGTH(stack) / 4;
__stack_dst = ORIGIN(stack);
__stack_phy = ORIGIN(stack);
__stack_src = LOADADDR(stack_kernel);
__stack_size = LENGTH(stack) / 4;

/* TSS de Intel */
__TSS_descr = ORIGIN(stack);
__TSS_descr_15_0 = (__TSS_descr & 0x0000FFFF);            /* Base de TSS */
__TSS_descr_23_16 = ((__TSS_descr >> 16) & 0x000000FF);
__TSS_descr_31_24 = ((__TSS_descr >> 24) & 0x000000FF);
__TSS_length = LENGTH(stack);                             /* Límite de TSS */
__TSS_length_15_0 = (__TSS_length & 0x0000FFFF);
__TSS_length_19_16 = ((__TSS_length >> 16) & 0x000000FF);

/* Stack de MR */
__STACK_START_16 = 0x9000;
__STACK_END_16 = 0xFFFF;

/*********************** Auxiliares ***********************/

/* Tabla de Dígitos y Datos */
__TABLA_ORIGIN = ORIGIN(tabla);             /* Buffer de Scan Codes */
__DATOS_ORIGIN = ORIGIN(datos);             /* Buffer para la Cantidad de ticks */

/* Buffers y Variables aux */
__BUFF_CIRC_INDEX = ORIGIN(datos) + 0x20;   /* Índice del Buffer Circular */
__BUFF_CIRC = ORIGIN(datos) + 0x30;         /* Buffer Circular */
__CANT_ENTER = ORIGIN(datos) + 0x24;        /* Cantidad de Enters apretados */
__CANT_PAG = ORIGIN(datos) + 0x28;          /* Cantidad de Páginas agregadas por el Page Fault Handler */

/*********************** Paginación ***********************/

/* Paginación */
__PAGE_SIZE = 0x1000;
__PT_START_T0 = ORIGIN(tarea0_pagetables);
__PT_START_T1 = ORIGIN(tarea1_pagetables);
__PT_START_T2 = ORIGIN(tarea2_pagetables);
__PT_START_T3 = ORIGIN(tarea3_pagetables);
__PT_START_T4 = ORIGIN(tarea4_pagetables);

/* Árboles de paginación */
__t0_page_table_dst = ORIGIN(tarea0_pagetables);
__t0_page_table_phy = ORIGIN(tarea0_pagetables);
__t0_page_table_size = LENGTH(tarea0_pagetables);

__t2_page_table_dst = ORIGIN(tarea2_pagetables);
__t2_page_table_phy = ORIGIN(tarea2_pagetables);
__t2_page_table_size = LENGTH(tarea2_pagetables);

__t1_page_table_dst = ORIGIN(tarea1_pagetables);
__t1_page_table_phy = ORIGIN(tarea1_pagetables);
__t1_page_table_size = LENGTH(tarea1_pagetables);

__t3_page_table_dst = ORIGIN(tarea3_pagetables);
__t3_page_table_phy = ORIGIN(tarea3_pagetables);
__t3_page_table_size = LENGTH(tarea3_pagetables);

__t4_page_table_dst = ORIGIN(tarea4_pagetables);
__t4_page_table_phy = ORIGIN(tarea4_pagetables);
__t4_page_table_size = LENGTH(tarea4_pagetables);

/************** Tarea 0: TXT, BSS, DATA, Stack ************/

/* Tarea 0 - TEXT */
__t0_text_dst = ORIGIN(tarea0_txt);
__t0_text_src = LOADADDR(t0_text);
__t0_text_size = LENGTH(tarea0_txt);
__t0_text_copysize = SIZEOF(t0_text);
__t0_text_phy = 0x00501000;

/* Tarea 0 - BSS */
__t0_bss_dst = ORIGIN(tarea0_bss);
__t0_bss_src = LOADADDR(t0_bss);
__t0_bss_size = LENGTH(tarea0_bss);
__t0_bss_phy = 0x00502000;

/* Tarea 0 - DATA */
__t0_data_dst = ORIGIN(tarea0_data);
__t0_data_phy = 0x00503000;
__t0_data_size = LENGTH(tarea0_data);

/* Tarea 0 - Stack */
__STACK_T0_START = ORIGIN(tarea0_stack);
__STACK_T0_END = ORIGIN(tarea0_stack) + LENGTH(tarea0_stack);
__STACK_T0_SIZE = LENGTH(tarea0_stack);
__t0_stack_dst = ORIGIN(tarea0_stack);
__t0_stack_phy = 0x1FFFC000;
__t0_stack_size = LENGTH(tarea0_stack) + 0x1000;

/************** Tarea 1: TXT, BSS, DATA, Stack ************/

/* Tarea 1 - TEXT */
__t1_text_dst = ORIGIN(tarea1_txt);
__t1_text_src = LOADADDR(t1_text);
__t1_text_size = LENGTH(tarea1_txt);
__t1_text_copysize = SIZEOF(t1_text);
__t1_text_phy = 0x00521000;

/* Tarea 1 - BSS */
__t1_bss_dst = ORIGIN(tarea1_bss);
__t1_bss_src = LOADADDR(t1_bss);
__t1_bss_size = LENGTH(tarea1_bss);
__t1_bss_phy = 0x00522000;
__TAREA1_RES = ORIGIN(tarea1_bss);        /* Resultado de la Suma de Tarea 1 */

/* Tarea 1 - DATA */
__t1_data_dst = ORIGIN(tarea1_data);
__t1_data_phy = 0x00523000;
__t1_data_size = LENGTH(tarea1_data);

/* Tarea 1 - Stack */
__STACK_T1_START = ORIGIN(tarea1_stack);
__STACK_T1_END = ORIGIN(tarea1_stack) + LENGTH(tarea1_stack);
__STACK_T1_SIZE = LENGTH(tarea1_stack);
__t1_stack_dst = ORIGIN(tarea1_stack);
__t1_stack_phy = 0x1FFFE000;
__t1_stack_size = LENGTH(tarea1_stack) + 0x1000;

/************** Tarea 2: TXT, BSS, DATA, Stack ************/

/* Tarea 2 - TEXT */
__t2_text_dst = ORIGIN(tarea2_txt);
__t2_text_src = LOADADDR(t2_text);
__t2_text_size = LENGTH(tarea2_txt);
__t2_text_copysize = SIZEOF(t2_text);
__t2_text_phy = 0x00531000;

/* Tarea 2 - BSS*/
__t2_bss_dst = ORIGIN(tarea2_bss);
__t2_bss_src = LOADADDR(t2_bss);
__t2_bss_size = LENGTH(tarea2_bss);
__t2_bss_phy = 0x00532000;
__TAREA2_RES = ORIGIN(tarea2_bss);        /* Resultado de la Suma de Tarea 2 */

/* Tarea 2 - DATA */
__t2_data_dst = ORIGIN(tarea2_data);
__t2_data_phy = 0x00533000;
__t2_data_size = LENGTH(tarea2_data);

/* Tarea 2 - Stack */
__STACK_T2_START = ORIGIN(tarea2_stack);
__STACK_T2_END = ORIGIN(tarea2_stack) + LENGTH(tarea2_stack);
__STACK_T2_SIZE = LENGTH(tarea2_stack);
__t2_stack_dst = ORIGIN(tarea2_stack);
__t2_stack_phy = 0x1FFFD000;
__t2_stack_size = LENGTH(tarea2_stack) + 0x1000;

/************** Tarea 3: TXT, BSS, DATA, Stack ************/

/* Tarea 3 - TEXT */
__t3_text_dst = ORIGIN(tarea3_txt);
__t3_text_src = LOADADDR(t3_text);
__t3_text_size = LENGTH(tarea3_txt);
__t3_text_copysize = SIZEOF(t3_text);
__t3_text_phy = 0x00541000;

/* Tarea 3 - BSS*/
__t3_bss_dst = ORIGIN(tarea3_bss);
__t3_bss_src = LOADADDR(t3_bss);
__t3_bss_size = LENGTH(tarea3_bss);
__t3_bss_phy = 0x00542000;
__TAREA3_RES = ORIGIN(tarea3_bss);        /* Resultado de la Suma de Tarea 2 */

/* Tarea 3 - DATA */
__t3_data_dst = ORIGIN(tarea3_data);
__t3_data_phy = 0x00543000;
__t3_data_size = LENGTH(tarea3_data);

/* Tarea 3 - Stack */
__STACK_T3_START = ORIGIN(tarea3_stack);
__STACK_T3_END = ORIGIN(tarea3_stack) + LENGTH(tarea3_stack);
__STACK_T3_SIZE = LENGTH(tarea3_stack);
__t3_stack_dst = ORIGIN(tarea3_stack);
__t3_stack_phy = 0x1FF0E000;
__t3_stack_size = LENGTH(tarea3_stack) + 0x1000;

/************** Tarea 4: TXT, BSS, DATA, Stack ************/

/* Tarea 4 - TEXT */
__t4_text_dst = ORIGIN(tarea4_txt);
__t4_text_src = LOADADDR(t4_text);
__t4_text_size = LENGTH(tarea4_txt);
__t4_text_copysize = SIZEOF(t4_text);
__t4_text_phy = 0x00551000;

/* Tarea 4 - BSS*/
__t4_bss_dst = ORIGIN(tarea4_bss);
__t4_bss_src = LOADADDR(t4_bss);
__t4_bss_size = LENGTH(tarea4_bss);
__t4_bss_phy = 0x00552000;
__TAREA4_RES = ORIGIN(tarea4_bss);        /* Resultado de la Suma de Tarea 2 */

/* Tarea 4 - DATA */
__t4_data_dst = ORIGIN(tarea4_data);
__t4_data_phy = 0x00553000;
__t4_data_size = LENGTH(tarea4_data);

/* Tarea 4 - Stack */
__STACK_T4_START = ORIGIN(tarea4_stack);
__STACK_T4_END = ORIGIN(tarea4_stack) + LENGTH(tarea4_stack);
__STACK_T4_SIZE = LENGTH(tarea4_stack);
__t4_stack_dst = ORIGIN(tarea4_stack);
__t4_stack_phy = 0x1FF0F000;
__t4_stack_size = LENGTH(tarea4_stack) + 0x1000;

/*************************** TSS **************************/

/* Tarea 0 - TSS */
__t0_tss_dst = ORIGIN(tarea0_tss);
__t0_tss_src = LOADADDR(t0_tss);
__t0_tss_phy = 0x1FFF8000;
__t0_tss_size = LENGTH(tarea0_tss) / 4;
__t0_tss_copysize = SIZEOF(t0_tss);
__T0_TSS_START = ORIGIN(tarea0_tss);
__T0_TSS_END = ORIGIN(tarea0_tss) + LENGTH(tarea0_tss);

/* Tarea 1 - TSS */
__t1_tss_dst = ORIGIN(tarea1_tss);
__t1_tss_src = LOADADDR(t1_tss);
__t1_tss_phy = 0x1FFFA000;
__t1_tss_size = LENGTH(tarea1_tss) / 4;
__t1_tss_copysize = SIZEOF(t1_tss);
__T1_TSS_START = ORIGIN(tarea1_tss);
__T1_TSS_END = ORIGIN(tarea1_tss) + LENGTH(tarea1_tss);

/* Tarea 2 - TSS */
__t2_tss_dst = ORIGIN(tarea2_tss);
__t2_tss_src = LOADADDR(t2_tss);
__t2_tss_phy = 0x1FFF9000;
__t2_tss_size = LENGTH(tarea2_tss) / 4;
__t2_tss_copysize = SIZEOF(t2_tss);
__T2_TSS_START = ORIGIN(tarea2_tss);
__T2_TSS_END = ORIGIN(tarea2_tss) + LENGTH(tarea2_tss);

/* Tarea 3 - TSS */
__t3_tss_dst = ORIGIN(tarea3_tss);
__t3_tss_src = LOADADDR(t3_tss);
__t3_tss_phy = 0x1FF01000;
__t3_tss_size = LENGTH(tarea3_tss) / 4;
__t3_tss_copysize = SIZEOF(t3_tss);
__T3_TSS_START = ORIGIN(tarea3_tss);
__T3_TSS_END = ORIGIN(tarea3_tss) + LENGTH(tarea3_tss);

/* Tarea 4 - TSS */
__t4_tss_dst = ORIGIN(tarea4_tss);
__t4_tss_src = LOADADDR(t4_tss);
__t4_tss_phy = 0x1FF02000;
__t4_tss_size = LENGTH(tarea4_tss) / 4;
__t4_tss_copysize = SIZEOF(t4_tss);
__T4_TSS_START = ORIGIN(tarea4_tss);
__T4_TSS_END = ORIGIN(tarea4_tss) + LENGTH(tarea4_tss);

/************************** Kernel ************************/

/* Main */
___kernel_dst = ADDR(kernel);
___kernel_src = LOADADDR(kernel);
___kernel_size = SIZEOF(kernel);
___kernel_phy = ADDR(kernel);

/************************ SysTables ***********************/

/* IDT y GDT */
___sys_table_dst = ADDR(tablas);
___sys_table_src = LOADADDR(tablas);
___sys_table_size = SIZEOF(tablas);
___sys_table_phy = ADDR(tablas);

/************************ Handlers ************************/

/* Rutinas e ISR */
___handler_dst = ADDR(handlers);
___handler_src = LOADADDR(handlers);
___handler_size = SIZEOF(handlers);
___handler_phy = ADDR(handlers);

/******************** Tabla de Dígitos ********************/

/* Tabla de Digitos */
__digit_table_dst = ORIGIN(tabla);
__digit_table_phy = ORIGIN(tabla);
__digit_table_size = LENGTH(tabla);

/************************* Datos **************************/

/* Data Random */
__data_dst = ORIGIN(datos);
__data_phy = ORIGIN(datos);
__data_size =  LENGTH(datos);

/********************** System Calls **********************/

/* System Call de Usuario (Nivel 3) */
___syscall_dst = ORIGIN(syscalls);
___syscall_phy = ORIGIN(syscalls);
___syscall_src = LOADADDR(syscall);
___syscall_size = LENGTH(syscalls);
___syscall_copysize = SIZEOF(syscall);

MEMORY
{
    keyboard_isr (wrx) : ORIGIN = 0x00000000, LENGTH = 0x00001000
    syscalls (wrx) : ORIGIN = 0x00010000, LENGTH = 0x00001000
    systables (wr) : ORIGIN = 0x00100000, LENGTH = 0x00001000
    tarea0_pagetables (wr) : ORIGIN = 0x00110000, LENGTH = 0x00001000
    tarea2_pagetables (wr) : ORIGIN = 0x00191000, LENGTH = 0x00001000
    tarea1_pagetables (wr) : ORIGIN = 0x00213000, LENGTH = 0x00001000
    tarea3_pagetables (wr) : ORIGIN = 0x00295000, LENGTH = 0x00001000
    tarea4_pagetables (wr) : ORIGIN = 0x00317000, LENGTH = 0x00001000
    kernel (wrx) : ORIGIN = 0x00500000, LENGTH = 0x00001000
    tarea0_txt (wrx) : ORIGIN = 0x00610000, LENGTH = 0x00001000
    tarea0_bss (wr) : ORIGIN = 0x00611000, LENGTH = 0x00001000
    tarea0_data (wr) : ORIGIN = 0x00612000, LENGTH = 0x00001000
    tabla (wr) : ORIGIN = 0x00510000, LENGTH = 0x00001000
    tarea1_txt (wrx) : ORIGIN = 0x00610000, LENGTH = 0x00001000
    tarea1_bss (wr) : ORIGIN = 0x00611000, LENGTH = 0x00001000
    tarea1_data (wr) : ORIGIN = 0x00612000, LENGTH = 0x00001000
    tarea2_txt (wrx) : ORIGIN = 0x00610000, LENGTH = 0x00001000
    tarea2_bss (wr) : ORIGIN = 0x00611000, LENGTH = 0x00001000
    tarea2_data (wr) : ORIGIN = 0x00612000, LENGTH = 0x00001000
    tarea3_txt (wrx) : ORIGIN = 0x00610000, LENGTH = 0x00001000
    tarea3_bss (wr) : ORIGIN = 0x00611000, LENGTH = 0x00001000
    tarea3_data (wr) : ORIGIN = 0x00612000, LENGTH = 0x00001000
    tarea4_txt (wrx) : ORIGIN = 0x00610000, LENGTH = 0x00001000
    tarea4_bss (wr) : ORIGIN = 0x00611000, LENGTH = 0x00001000
    tarea4_data (wr) : ORIGIN = 0x00612000, LENGTH = 0x00001000
    datos (wr) : ORIGIN = 0x005E0000, LENGTH = 0x00001000
    tarea0_tss (wr) : ORIGIN = 0x00614000, LENGTH = 0x00001000
    tarea2_tss (wr) : ORIGIN = 0x00614000, LENGTH = 0x00001000
    tarea1_tss (wr) : ORIGIN = 0x00614000, LENGTH = 0x00001000
    tarea3_tss (wr) : ORIGIN = 0x00614000, LENGTH = 0x00001000
    tarea4_tss (wr) : ORIGIN = 0x00614000, LENGTH = 0x00001000
    stack (wr) : ORIGIN = 0x1FFFB000, LENGTH = 0x00001000
    tarea0_stack (wr) : ORIGIN = 0x00613000, LENGTH = 0x00001000
    tarea2_stack (wr) : ORIGIN = 0x00613000, LENGTH = 0x00001000
    tarea1_stack (wr) : ORIGIN = 0x00613000, LENGTH = 0x00001000
    tarea3_stack (wr) : ORIGIN = 0x00613000, LENGTH = 0x00001000
    tarea4_stack (wr) : ORIGIN = 0x00613000, LENGTH = 0x00001000
    rom (rx) : ORIGIN = 0xFFFF0000, LENGTH = 0x0000FFF0
    rom_reset (rx) : ORIGIN = 0xFFFFFFF0, LENGTH = 0x00000010
}

SECTIONS
{
    handlers :
    {
        *(.handlers);
    } > keyboard_isr AT > rom

    syscall :
    {
      *(.systemcall_funcs);
      *(.funcion_ram);
    } > syscalls AT > rom

    tablas :
    {
        *(.IDT_table);
        *(.GDT_table_ram);
    } > systables AT > rom

    kernel :
    {
        *(.kernel32);
        *(.systemcall);
    } > kernel AT > rom

    t0_text :
    {
      *(.txt_tarea0);
    } > tarea0_txt AT > rom

    t0_bss :
    {
      *(.bss_tarea0);
    } > tarea0_bss AT > rom

    t0_data :
    {
      *(.data_tarea0);
    } > tarea0_data AT > rom

    t1_text :
    {
      *(.txt_tarea1);
    } > tarea1_txt AT > rom

    t1_bss :
    {
      *(.bss_tarea1);
    } > tarea1_bss AT > rom

    t1_data :
    {
      *(.data_tarea1);
    } > tarea1_data AT > rom

    t2_text :
    {
      *(.txt_tarea2);
    } > tarea2_txt AT > rom

    t2_bss :
    {
      *(.bss_tarea2);
    } > tarea2_bss AT > rom

    t2_data :
    {
      *(.data_tarea2);
    } > tarea2_data AT > rom

    t3_text :
    {
      *(.txt_tarea3);
    } > tarea3_txt AT > rom

    t3_bss :
    {
      *(.bss_tarea3);
    } > tarea3_bss AT > rom

    t3_data :
    {
      *(.data_tarea3);
    } > tarea3_data AT > rom

    t4_text :
    {
      *(.txt_tarea4);
    } > tarea4_txt AT > rom

    t4_bss :
    {
      *(.bss_tarea4);
    } > tarea4_bss AT > rom

    t4_data :
    {
      *(.data_tarea4);
    } > tarea4_data AT > rom

    data :
    {
      *(.bss);
      *(.data);
    } > datos AT > rom

    t0_tss :
    {
      *(.t0_tss);
    } > tarea0_tss AT > rom

    t1_tss :
    {
      *(.t1_tss);
    } > tarea1_tss AT > rom

    t2_tss :
    {
      *(.t2_tss);
    } > tarea2_tss AT > rom

    t3_tss :
    {
      *(.t3_tss);
    } > tarea3_tss AT > rom

    t4_tss :
    {
      *(.t4_tss);
    } > tarea4_tss AT > rom

    stack_kernel :
    {
      *(.tss_global);
    } > stack AT > rom

    rom :
    {
        *(.start16);
        *(.start32);
        *(.init32);
        *(.utils16);
        *(.funcion_rom);
        *(.GDT_table);
    } > rom

    /* Reset Vector lo dejo siempre al fondo de la ROM */
    fill_rom :
    {
        . = ORIGIN(rom_reset) - 1;
        BYTE(0x90);
    } > rom = 0x90

    vector_reset :
    {
        *(.resetvec);
    } > rom_reset

    end_rom :
    {
        . = ORIGIN(rom_reset) + LENGTH(rom_reset) - 1;
        BYTE(0x90);
    } > rom_reset = 0x90

}
