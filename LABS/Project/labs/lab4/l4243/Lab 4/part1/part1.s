.include "nios_macros.s"

.global _start

.equ ADDR_JP2, 0x10000070 

_start:

	movia  r8, ADDR_JP2
	movia  r13, 0x07f557ff       
	stwio  r13, 4(r8)
	movia  r13, 0xffffffff			# resetting all value to 1 
	stwio  r13, 0(r8)

loop:

	andi   r13, r13, 0x0000000f 	# enabling the motor
	addi  r13, r13, 0xfffffbf0 		# sensor 0
	stwio  r13, 0(r8)   			
	ldwio  r14, 0(r8)
	srli   r14, r14, 11
	andi   r14, r14, 0x1
	bne    r0, r14, loop  			# checking the valid bit for sensor 0
	ldwio  r11, 0(r8)
	srli   r11, r11, 27
	andi   r11, r11, 0x0f  

good:

	andi   r13, r13, 0x0000000f 	# enabling the motor
	addi   r13, r13, 0xffffeff0 	# sensor 1
	stwio  r13, 0(r8) 			
	ldwio  r14, 0(r8)
	srli   r14, r14, 13
	andi   r14, r14, 0x1
	bne    r0, r14, good 			# checking the valid bit for sensor 1
	ldwio  r12, 0(r8)
	srli   r12, r12, 27
	andi   r12, r12, 0x0f  

	beq    r12, r11, equal  		# if both sensor values are same	
	
	bge    r12, r11, forward		# if the value of sensor 1 is greater than the value of sensor 0 

backward:

	movia  r13, 0xfffffffe       	# enabling the motor, diretion to backwards
  	stwio  r13, 0(r8)	

  	br loop
	
	
forward: 							

	movia  r13, 0xfffffffc			# enabling the motor, diretion to forward       
  	stwio  r13, 0(r8)

  	br loop	

	
equal:

	movia  r13, 0xffffffff      	# motor disabled
  	stwio  r13, 0(r8)

  	br loop



