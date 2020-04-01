USE16
EXTERN start16

SECTION .resetvec
reset_vector:
    cli
    cld
    jmp start16
