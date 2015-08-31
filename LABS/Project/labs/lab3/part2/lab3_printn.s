# /********
#  * 
#  * Write the assembly function:
#  *     printn ( char * , ... ) ;
#  * Use the following C functions:
#  *     printHex ( int ) ;
#  *     printOct ( int ) ;
#  *     printDec ( int ) ;
#  * 
#  * Note that 'a' is a valid integer, so movi r2, 'a' is valid, and you don't need to look up ASCII values.
#  ********/

.global	printn
printn:
addi sp, sp, -48

# Saving the registers on the stack
stw ra,0(sp)
stw r16,4(sp)
stw r17,8(sp)
stw r18,12(sp)
stw r19,16(sp)
stw r20,20(sp)
stw r21,24(sp)
stw r22,28(sp)
stw r23,32(sp)
stw r5,36(sp)
stw r6,40(sp)
stw r7,44(sp)

# Initializing the offset from sp
# i.e the number of bytes that must be added to sp to get the corresponding argument
movi r17,36

# Initializing registers so that we can compare the characters in the char array
# and call the appropriate subroutine
movi r18,'O'
movi r19,'D'
movi r20,'H'

# copying the address that r4 is pointing to in r23
mov r23,r4
 
LOOP:
	ldb r21, 0(r23)		# loading the character(byte) that r23 is pointing to in r21
	add r16, r17, sp	# adding the offset to sp to get the address(r16) of the value to be passed as argument in print
	ldw r4, 0(r16)		# loading the integer(word) from r16 into r4
	beq r21, r20, PRINTHEX
	beq r21, r19, PRINTDEC
	beq r21, r18, PRINTOCT
	beq r21, r0, ENDLOOP
	  
# Prints Number in Hex
PRINTHEX:	
	call printHex 
	br INCREMENT	

# Prints Number in Decimal
PRINTDEC:
	call printDec	
	br INCREMENT

# Prints Number in Octal
PRINTOCT:
	call printOct	

# Incrementing the char array counter, the offset from sp
INCREMENT:
	addi r23, r23, 1
	addi r17, r17, 4
	br LOOP

  
ENDLOOP:	

# Restoring registers from stack
ldw r23, 32(sp)
ldw r22, 28(sp)
ldw r21, 24(sp)
ldw r20, 20(sp)
ldw r19, 16(sp)
ldw r18, 12(sp)
ldw r17, 8(sp)
ldw r16, 4(sp)
ldw ra, 0(sp)
addi sp, sp, 48 
ret
