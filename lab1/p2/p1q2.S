    .include "nios_macros.s"
    .global _start
_start:
    /* the following two instr. (orhi and ori)
       are what movia converts to */
    orhi    r2, r0, %hi(X)
    ori     r2, r2, %lo(X)
    movia   r3, Y
    movia   r4, N
    ldw     r4, 0(r4)
    add     r5, r0, r0
LABEL:
    ldw     r6, 0(r2)
    stw     r6, 0(r3)
    addi    r2, r2, 4
    addi    r3, r3, 4
    subi    r4, r4, 1
    bgt     r4, r0, LABEL
STOP:
    br STOP
.data
N:
    .word 6
X:
    .word 5, 3, -6, 19, 8, 12
Y:
    .word 0, 0, 0, 0, 0, 0

