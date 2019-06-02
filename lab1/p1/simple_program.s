.text
	.equ	LEDs,		0xFF200000
	.equ	SWITCHES,	0xFF200040

	.global _start
_start:
	movia	r2, LEDs		# Address of LEDs         
	movia	r3, SWITCHES	# Address of switches

LOOP:
	ldwio	r4, 0(r3)		# Read the state of switches

	andi r5, r4, 0x1F		# r5 holds the state of the least significant 5 bits
	srli r6, r4, 5			# r6 holds the state of the most signinficant 5 bits
	add r4, r5, r6			# r4 = r5 + r6
	
	stwio	r4, 0(r2)		# Display the state on LEDs
	br		LOOP			# Go to branch LOOP

.end