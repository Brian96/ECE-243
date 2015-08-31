.include "nios_macros.s"

.global	_start
_start: 

	.equ	ADDR_JP2,0x10000070


	movia	r8,	ADDR_JP2
	movia	r10,	0x07f557ff		#set direction for motors and sensors to output and sensor data registers to inputs
	stwio	r10,	4(r8)
	
	loopfirstsensor:
	movia	r11,	0xfffffbfc		#enable sensor 0, enalbe motor 0
	stwio	r11,	0(r8)
	ldwio	r5,	0(r8)
	srli	r5,	r5,11
	andi	r5,	r5,0x1
	bne	r0,	r5,loopfirstsensor
	br good

	
	loopsecondsensor:
	movia	r13,	0xffffeffe		#enable sensor 1, enalbe motor 0
	stwio	r13,	0(r8)
	ldwio	r6,	0(r8)
	srli	r6,	r6,13
	andi	r6,	r6,0x1
	bne	r0,	r6,loopsecondsensor

	good:
	ldwio	r10,	0(r8)
	srli	r10,	r10,27
	andi	r10,	r10,0x0f
	movi	r12,	0x05
	movi 	r14,	0x07
	beq	r10,	r12,FORWARD
	beq 	r10,	r14,BACKWARD
	
	FORWARD:
	blt	r10,	r12,loopfirstsensor
	br loopsecondsensor
	
	BACKWARD:
	blt	r10,	r14,loopsecondsensor
	br loopfirstsensor
.end