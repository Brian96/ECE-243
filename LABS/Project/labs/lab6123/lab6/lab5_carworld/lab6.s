#.include "nios_macro.s"

.section .exceptions, "ax"

IHANDLER: 

# storing callee saved 
addi sp,sp, -44
stw ea, 0(sp)				# saving ea 
stw et, 4(sp)				# saving et 
rdctl et, ctl1
stw et, 8(sp)				# saving ctl1
stw r16, 12(sp)
stw r18, 20(sp)
stw r19, 24(sp)
stw r11, 28(sp)
stw r12, 32(sp)
stw r21, 36(sp)
stw r22, 40(sp)

movia r16,JTAG_UART


rdctl et, ctl4
andi et, et, 0x1 						 #check if interrupt pending IRQ0 - highest priority (TIMER)
bne	 et, r0, HANDLE_TIMER

rdctl et, ctl4
andi et, et, 0x100                          #check for bit 8
bne et, r0, HANDLE_JTAG_UART


HANDLE_TIMER:
#do something



# send ACK for TIMER
movia et, TIMER
stwio r0, 0(et)				
br EXIT_HANDLER


HANDLE_JTAG_UART:
#do something
stwio r11, 0(r16)
stwio r12, 0(r16)


# send ACK for JTAG_UART
POLL_JTAG:
	ldwio r17, 0(r16) 		# Read from  JTAG
	andi et, r17, 0x8000 	# Checking if 15th bit in r2 is 1
	beq et, r0, POLL_JTAG
	andi r17, r17, 0x00FF 	# Data is in the first 8 bits, FF 11111111

	

EXIT_HANDLER:

ldw ea, 0(sp)
ldw et, 8(sp)
wrctl  ctl1, et
ldw et, 4(sp)
ldw r16, 12(sp)
ldw r17, 16(sp)
ldw r18, 20(sp)
ldw r19, 24(sp) 
ldw r11, 28(sp)
ldw r12, 32(sp)
ldw r21, 36(sp)
ldw r22, 40(sp)
addi sp,sp,44

subi ea,ea,4
eret

##################################################################################
.text
.global _start

.equ JTAG, 0x10001020 			#address of JTAG - car device
.equ JTAG_UART, 0x10001000		#address of communicatoon device
.equ TIMER, 0x10002000			#initializing timer address 
.equ PERIOD, 0x08F0D180			#timer period of 1 second
.equ RED_LEDS, 0x10000000		#LEDR

_start:

movia r16, TIMER 

#configure device : timer
movui r17, %lo(PERIOD)
stwio r17, 8(r16)
movui r17, %hi(PERIOD)
stwio r17, 12(r16)
stwio r0, 0(r16)				#clear timer
movi r17, 0b111				#initializing to interrupt, continue and start
stwio r17, 4(r16)	

#configure device : JTAG_UART
movia r18, JTAG_UART
movi et, 0x1 			#Enable read interrupt
stwio et, 4(r18)

#enable IRQ line
movi et, 0x101 				#IRQ0 for timer, IRQ8 for JTAG_UART
wrctl ctl3, et				#ctl3 - ienable

#enable external interrupts

movi et, 0b1
wrctl ctl0, et 				#set PIE = 1 
#####################################################################################

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




