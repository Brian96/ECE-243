#.include "nios_macro.s"

.global _start

.equ JTAG, 0x10001020 			#address of JTAG


_start:
movia r7, JTAG				#save address of JTAG in r7

ACCELERATE:
	call WRITE 				# poll to write
	movi r5, 4				# 4 : changing acceleration.
	stwio r5, 0(r7)			# send to device
	call WRITE				# poll to write
	movi r8, 40				# pass value of acceleration
	stwio r8, 0(r7)			# send to device



WRITE_POLL:
movi r14, 40			
call WRITE				# poll to write
movi r5, 3				# 3 : read value of sensors and speed		
stwio r5, 0(r7) 		# sending to device


READ_PACKET:
call READ				# poll to read

READ_SENSOR:

call READ
mov r12, r2				# copy sensor value returned as r2


READ_SPEED:
call READ
mov r11, r2				# copy speeed

#depending on what sensor value, you send it to the corresponding label		

movi r13, 0x1f
beq r12,r13,STRAIGHT

movi r13, 0x1e
beq r12,r13,SENSOR1


movi r13, 0x1c
beq r12,r13,SENSOR2

movi r13, 0x0f
beq r12,r13,SENSOR3

movi r13, 0x07
beq r12,r13,SENSOR4

br WRITE_POLL



READ:
	read_:
	ldwio r2, 0(r7) 	# Read from  JTAG
	andi r3, r2, 0x8000 # Checking if 15th bit in r2 is 1
	beq r3, r0, read_
	andi r2, r2, 0x00FF # Data is in the first 8 bits, FF 11111111
	ret

WRITE:

	write_:
	ldwio r3, 4(r7) 	# Load from the JTAG, base 4 because it has spaces available for writing
	srli r3, r3, 16 	# we want to see if space is available for writing so we shift by 16 bits. :)
	beq r3, r0, write_
	ret 



STRAIGHT:
	call WRITE
	movi r5, 5			# 5 : angle
	stwio r5, 0(r7) 	# sending 5 to JTAG to set angle
	
	call WRITE
	movi r5, 0 			# because all sensors are on, so no angle change needed
	stwio r5, 0(r7)
	
	movi r5, 47					# max speed
	bgt r11, r5,DECCELERATE		# if greater than max speed, then deccelerate
	call WRITE
	movi r5, 4 				# 4 : change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8, 127			# if less than max speed, then accelerate
	stwio r8, 0(r7)
	br WRITE_POLL


DECCELERATE:
	call WRITE
	movi r5, 4 				# change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8, -35			# acceleration value
	stwio r8, 0(r7)
	br WRITE_POLL




SENSOR1:
	movi r5, 5					# 5 : change steering
	stwio r5, 0(r7)
	call WRITE
	movi r5, 84					# steering value
	stwio r5, 0(r7)
	blt r11, r14,WRITE_POLL 
	movi r5, 4 					# 4 : change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8, -64				# acceleration value
	stwio r8, 0(r7)
	br WRITE_POLL


SENSOR2:
	movi r5, 5					# 5 : change steering
	stwio r5, 0(r7)
	call WRITE
	movi r5, 100				# steering value
	stwio r5, 0(r7)
	blt r11, r14,WRITE_POLL 
	movi r5, 4					# 4: change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8,  -64				# acceleration value
	stwio r8, 0(r7)
	br WRITE_POLL




SENSOR3:
	movi r5, 5					# 5 : change steering
	stwio r5, 0(r7)
	call WRITE
	movi r5, -64				# steering value
	stwio r5, 0(r7)
	blt r11, r14,WRITE_POLL 
	movi r5, 4 					# change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8, -64				# acceleration value
	stwio r8, 0(r7)
	br WRITE_POLL


SENSOR4:
	movi r5, 5					# 5 : change steering
	stwio r5, 0(r7)
	call WRITE
	movi r5, -64				# steering value
	blt r11, r14,WRITE_POLL 
	movi r5, 4 					# change acceleration
	stwio r5, 0(r7)
	call WRITE
	movi r8, -64				# acceleration value
	stwio r8, 0(r7)
	br WRITE_POLL




