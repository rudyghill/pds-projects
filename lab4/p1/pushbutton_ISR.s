	.include "address_map_nios2.s"
	.extern CURRENT_SPEED
/******************************************************************************
 * Pushbutton - Interrupt Service Routine
 *
 * This routine checks which KEY has been pressed and updates the global
 * variables as required.
 ******************************************************************************/
	.global	PUSHBUTTON_ISR
PUSHBUTTON_ISR:
	subi	sp, sp, 60				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r2, 4(sp)
	stw		r3, 8(sp)
	stw		r4, 12(sp)
	stw		r5, 16(sp)
	stw		r6, 20(sp)
	stw		r7, 24(sp)
	stw		r8, 28(sp)
	stw		r9, 32(sp)
	stw		r10, 36(sp)
	stw		r11, 40(sp)
	stw		r12, 44(sp)
	stw		r13, 48(sp)
	stw 	r14, 52(sp)
	stw		r15, 56(sp)

	movia	r10, KEY_BASE			# base address of pushbutton KEY parallel port
	movia 	r14, CURRENT_SPEED
	movia	r16, TIMER_BASE		# store interval timer base address
	
	movi	r3, 1	# SLOWEST
	movi 	r4, 2	
	movi 	r5, 3
	movi 	r6, 4	# DEFAULT
	movi 	r7, 5
	movi	r8, 6
	movi 	r9, 7	# FASTEST

	ldwio	r11, 0xC(r10)			# read edge capture register
	stwio	r11, 0xC(r10)			# clear the interrupt
	ldw 	r15, 0(r14)	  

CHECK_KEY0:	# Speed up Scrolling
	andi	r13, r11, 0b0001		# check KEY0
	beq		r13, r0, CHECK_KEY1
	beq 	r15, r9, END_PUSHBUTTON_ISR
	addi	r15, r15, 1
	br SPEED_HANDLER

CHECK_KEY1:	# Slow down scrolling
	andi	r13, r11, 0b0010		# check KEY1
	beq		r13, r0, END_PUSHBUTTON_ISR
	beq 	r15, r3, END_PUSHBUTTON_ISR
	subi	r15, r15, 1
	br SPEED_HANDLER

SPEED_HANDLER:
	stw 	r15, 0(r14)
	beq 	r15, r3, SLOWEST
	beq 	r15, r4, SLOWER
	beq 	r15, r5, SLOW
	beq 	r15, r6, DEFAULT
	beq 	r15, r7, FAST
	beq 	r15, r8, FASTER
	beq 	r15, r9, FASTEST 

FASTEST:
	movia	r12, 10000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

FASTER:
	movia	r12, 10000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

FAST:
	movia	r12, 15000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

DEFAULT:
	movia	r12, 20000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

SLOW:
	movia	r12, 25000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

SLOWER:
	movia	r12, 28000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

SLOWEST:
	movia	r12, 32000000		# 1/(100 MHz) x (5 x 10^6) = 50 msec #default speed
	br STORE_SPEED

STORE_SPEED:
	sthio	r12, 8(r16)			# store the low half word of counter start value (the lower half of a 32 bit number)
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# high half word of counter start value (the higher half of a 32 bit number)
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1 (CONT when timer reaches zero it automatically reloads specified starting count value)
	sthio	r15, 4(r16)			# (START is used to commence/suspend the operation) (ITO used for generating interrupts)
	br END_PUSHBUTTON_ISR

END_PUSHBUTTON_ISR:
	ldw		ra, 0(sp)
	ldw		r2, 4(sp)
	ldw		r3, 8(sp)
	ldw		r4, 12(sp)
	ldw		r5, 16(sp)
	ldw		r6, 20(sp)
	ldw		r7, 24(sp)
	ldw		r8, 28(sp)
	ldw		r9, 32(sp)
	ldw		r10, 36(sp)
	ldw		r11, 40(sp)
	ldw		r12, 44(sp)
	ldw		r13, 48(sp)
	ldw 	r14, 52(sp)
	ldw		r15, 56(sp)
	addi	sp,  sp, 60

	ret
	.end	
