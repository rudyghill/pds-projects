.text
	.equ	HEX3_HEX0_BASE, 0xFF200020
	.equ	KEY_BASE,		0xFF200050
	.global _start
left:
	.word 0x79, 0x49, 0x49, 0x49, 0x00, 0x00, 0x00, 0x00
right:
	.word 0x4F, 0x49, 0x49, 0x49, 0x00, 0x00, 0x00, 0x00
_start:
	movia	r2, HEX3_HEX0_BASE # Address of switches
	movia	r3, KEY_BASE
	movia	r4, left
	movia	r5, right
	movi	r6, 8 # length
	movi	r7, 0 # state
	movi	r8, 0 # direction
	movi 	r10, 0 # screen buffer
	stwio	r0, 0(r2) # initially black screen
LOOP:	          
	# Reset r5 to 5,000,000
	ori 	r9, r0, 0x4B40
	orhi	r9, r9, 0x004C
DELAY:
	# subtract 1 from r5 until it's zero
	subi	r9, r9, 1
	bgt 	r9, r0, DELAY
	br 		CHECK
HANDLER:
	ldw 	r4, 0(r3)
	stwio	r4, 0(r2)
	br  	LOOP
CHECK:
	ldw 	r11, 0(r3)
	bgt 	r11, r0, RESET # If button is pushed enter the restart handler
	beq 	r8, r0, SEQ1 # If direction is left go to sequence 1
	br  	SEQ2 # If direction is right go to sequence 2
SEQ1:
	slli	r10, r10, 8 # Shift by one byte (or one 7-seg display) to the left
	ldw 	r11, 0(r4) # Load one byte word from left
	or  	r10, r10, r11 # OR byte into the end of the register
	stwio	r10, 0(r2) # Put register on screen
	addi	r4,	r4, 4 # Increment left address by one word
	addi	r7, r7, 1 # Increment state register by one
	beq 	r7, r6, RESET1 # Restart when the length is readched
	br  	LOOP
SEQ2:
	srli	r10, r10, 8 # Shift by one byte (or one 7-seg display) to the left
	ldw 	r11, 0(r5) # Load one byte word from right
	slli	r11, r11, 24
	or  	r10, r10, r11 # OR byte into the end of the register
	stwio	r10, 0(r2) # Put register on screen
	addi	r5,	r5, 4 # Increment right address by one word
	addi	r7, r7, 1 # Increment state register by one
	beq 	r7, r6, RESET2 # Restart when the length is readched
	br  	LOOP
RESET:
	beq 	r8, r0, RESET2
	br  	RESET1
RESET1:
	movi	r8, 0 # set direction to left
	movi	r7, 0
	movi	r10, 0
	movia	r4, left
	br  	LOOP
RESET2:
	movi 	r8, 1 # Set direction to right
	movi	r7, 0
	movi	r10, 0
	movia	r5, right
	br  	LOOP
.end