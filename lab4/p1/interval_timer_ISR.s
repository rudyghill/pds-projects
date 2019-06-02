	.include "address_map_nios2.s"
	.extern	PATTERN					# externally defined variables
	.extern POSITION
	.extern MAX
	.extern PATTERN_ADDRESS
	.extern SEG_STATUS
/*******************************************************************************
 * Interval timer - Interrupt Service Routine
 *
 * Shifts a PATTERN being displayed. The shift direction is determined by the 
 * external variable SHIFT_DIR. Whether the shifting occurs or not is determined
 * by the external variable SHIFT_ON.
 ******************************************************************************/
	.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi	sp,  sp, 40				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r4, 4(sp)
	stw		r5, 8(sp)
	stw		r6, 12(sp)
	stw		r8, 16(sp)
	stw		r10, 20(sp)
	stw		r20, 24(sp)
	stw		r21, 28(sp)
	stw		r22, 32(sp)
	stw		r23, 36(sp)
	
	movia	r10, TIMER_BASE			# interval timer base address
	sthio	r0,  0(r10)				# clear the interrupt
	
	movia 	r10, PATTERN			# Array containing "HELLO BUFFS"
	movia 	r11, PATTERN_ADDRESS
	movia 	r12, POSITION
	movia 	r13, SEG_STATUS
	movia 	r14, MAX
	movia 	r15, HEX3_HEX0_BASE
	ldw 	r20, 0(r13)				# SEG_STATUS
	ldw		r21, 0(r11)				# PATTERN_ADDRESS
	ldw		r22, 0(r14)  			# MAX
	ldw 	r23, 0(r12)				# POSITION

SHIFT:
	slli 	r20, r20, 8 # shift r20 8 bits to the left to store next letter
	ldw  	r5, (r21) 	# load value from PATTERN
	or   	r20, r20, r5 # store next letter into first 8 bits of 7 seg register
	stw  	r20, 0(r13) # save r20
	addi 	r21, r21, 4 # add 4 to PATTERN_ADDRESS for offset to get next value
	stw  	r21, 0(r11) # save r21
	addi 	r23, r23, 4 # add 4 to POSITION
	stw  	r23, 0(r12) # save r23
	beq  	r23, r22, RESET
	br   	DISPLAY

RESET:
	stw  	r0, 0(r12) # reset POSITION 
	addi  	r21, r21, -76 # subtract 76 to get back to base address of array
	stw  	r21, 0(r11)
	br   	DISPLAY

DISPLAY:
	stw  	r20, 0(r15)
	br   	END_INTERVAL_TIMER_ISR

END_INTERVAL_TIMER_ISR:
	ldw		ra, 0(sp)				# restore registers
	ldw		r4, 4(sp)
  	ldw		r5, 8(sp)
	ldw		r6, 12(sp)
	ldw		r8, 16(sp)
	ldw		r10, 20(sp)
	ldw		r20, 24(sp)
	ldw		r21, 28(sp)
	ldw		r22, 32(sp)
	ldw		r23, 36(sp)	
	addi	sp,  sp, 40				# release the reserved space on the stack

	ret
	.end	