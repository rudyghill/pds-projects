.text
	.equ	HEX3_HEX0_BASE, 0xFF200020
	.global _start
.data
pattern: # A, B, A, B, A, B, C, blank, C, blank, C, blank
	.word	0x49494949, 0x36363636, 0x49494949, 0x36363636, 0x49494949, 0x36363636, 0x7F7F7F7F, 0x00000000, 0x7F7F7F7F, 0x00000000, 0x7F7F7F7F, 0x00000000, 
message:  # HELLO bUFFS---    
	.word	0x76, 0x79, 0x38, 0x38, 0x3F, 0x00, 0x7C, 0x3E, 0x71, 0x71, 0x6D, 0x40, 0x40, 0x40, 0x00, 0x00, 0x00, 0x00
_start:
	movia	r2, HEX3_HEX0_BASE # Address of switches
	movia	r3, message # Address of message
	movi 	r4, 0x0 # r4 holds the state of the process
	movia	r8, pattern # Address of pattern
	movi 	r10, 18 # Message done, see r4
	movi	r11, 30 # Flashing done, see r4
	stwio	r0, 0(r2) # initially black screen
LOOP:	          
	# Reset r5 to 5,000,000
	ori 	r5, r0, 0x4B40
	orhi	r5, r5, 0x004C
	br  	DELAY
DELAY:
	# subtract 1 from r5 until it's zero
	subi	r5, r5, 1
	bgt 	r5, r0, DELAY
	br 		HANDLER # then enter the handler
HANDLER:
	blt 	r4, r10, SCROLL # not done with the scrolling yet
	blt 	r4, r11, FLASH # not done with the flashing yet
	br  	RESET # Completely done, restart registers
FLASH:
	ldw 	r9, 0(r8) # Load 4 byte word from pattern
	stw 	r9, 0(r2) # Put register on screen
	addi	r8, r8, 4 # Increment pattern address by one word
	addi	r4, r4, 1 # Increment state register by one
	br  	LOOP
SCROLL:
	slli	r6, r6, 8 # Shift by one byte (or one 7-seg display) to the left
	ldw 	r7, 0(r3) # Load one byte word from message
	or  	r6, r6, r7 # OR byte into the end of the register
	stwio	r6, 0(r2) # Put register on screen
	addi	r3,	r3, 4 # Increment message address by one word
	addi	r4, r4, 1 # Increment state register by one
	br  	LOOP
RESET:
	movi	r4, 0x0 # Reset state register
	movia	r3, message  # Reset message address
	movia	r8, pattern # Reset the pattern address
	br  	LOOP
.end