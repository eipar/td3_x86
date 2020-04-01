/*********** Paginación ***********/

/* Máscara de 4K para Paginación - Alineación */
#define MASK_4K_PAGE_DIR    0xFFC00000
#define MASK_4K_PAGE_TABLE  0x003FF000
#define CONST_4K            4096
#define CONST_4K_HEX        0x1000

/* Máscara para correr la dirección lineal 22 bytes */
#define MASK_PD             0x16

/* Máscara para correr la dirección lineal 12 bytes */
#define MASK_PT             0xC

/* Alinear la base del árbol 4K */
#define MASK_BASE           0xFFFFF000

/* Atributos */
/* Page Directory Entry */
/************************/
/****7*6*5*4*3*2*1*0*****/
/************************/
/****P*I*A*P*P*S*R*P*****/
/****S*G***C*W*-*-*******/
/******N***D*T*U*W*******/
/************************/
/************************/
#define PDE_ATRR_S          0x03          //Atributo del Page Directory Entry - Supervisor
#define PDE_ATRR_U          0x07          //Atributo del Page Directory Entry - Usuario
/*** Page Table Entry ***/
/************************/
/**8*7*6*5*4*3*2*1*0*****/
/************************/
/**G*P*D*A*P*P*S*R*P*****/
/****A*****C*W*-*-*******/
/****T*****D*T*U*W*******/
/************************/
/************************/
#define PTE_ATRR_S_RO       0x01          //Atributo del Page Table Entry - Supervisor, Read Only
#define PTE_ATRR_S_RW       0x03          //Atributo del Page Table Entry - Supervisor, Readable/Writable
#define PTE_ATRR_U_RO       0x05          //Atributo del Page Table Entry - Usuario, Read Only
#define PTE_ATRR_U_RW       0x07          //Atributo del Page Table Entry - Usuario, Readable/Writable

/* Máscara del Error Code del Page Fault Handler */

#define MASK_ERR_NOT_PRESENT  0x00000001
#define ERR_NOT_PRESENT       0x00000000          //Máscara de Página no Presente
#define DIRR_PHY_NOT_PRESENT  0x10000000          //Dirección Física dónde empezar a paginar
