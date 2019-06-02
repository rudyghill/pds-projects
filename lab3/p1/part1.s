.text
.global sum_two
sum_two:
    add r2, r4, r5
    ret # no caller registers used
.text
.global op_two
op_two:
    add r2, r4, r5
    ret # no caller registers used
.global op_three
op_three:
    addi sp, sp, -0xc
    stw ra, 8(sp)
    stw fp, 4(sp)
    addi fp, sp, 4
    stw r6, 0(sp)

    call op_two
    mov r4, r2
    ldw r6, 0(sp)
    mov r5, r6
    call op_two

    ldw ra, 8(sp)
    ldw fp, 4(sp)
    addi sp, sp, 0xc
    ret
.global fibonacci
fibonacci:
   beq     r4, r0, fibZERO
   addi    r2, r0, 1
   beq     r4, r2, fibONE
   subi    sp, sp, 0xC
   stw     ra, 8(sp)
   stw     r17, 4(sp)
   stw     r16, 0(sp)
   add     r16, r4, r0
   subi    r4, r4, 0x1
   call    fibonacci
   add     r17, r2, r0
   subi    r4, r16, 0x2
   call    fibonacci
   add     r2, r17, r2
   br      fibEND
fibZERO:
   add     r2, r2, r0
   ret
fibONE:
   add     r2, r0, 0x1
   ret
fibEND:
   ldw     ra, 8(sp)
   ldw     r17, 4(sp)
   ldw     r16, 0(sp)
   addi    sp, sp, 0xC
	ret