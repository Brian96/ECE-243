/********
 * 
 * Write the assembly function:
 *     printn ( char * , ... ) ;
 * Use the following C functions:
 *     printHex ( int ) ;
 *     printOct ( int ) ;
 *     printDec ( int ) ;
 * 
 * Note that 'a' is a valid integer, so movi r2, 'a' is valid, and you don't need to look up ASCII values.
 ********/

.global	printn
printn:
# ...

    ret




.global printn
printn:
addi sp,sp,-48

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

movi r17,36

movi r18,'O'
movi r19,'D'
movi r20,'H'

mov r23,r4

LOOP:
	ldb r21, 0(r23)
	add r16,r17, sp
	ldw r4, 0(r16)	
	beq r21, r20, PRINTHEX
	beq r21, r19, PRINTDEC
	beq r21, r18, PRINTOCT
	beq r21, r0, ENDLOOP

PRINTHEX:
	call printHex
	br INCREMENT

PRINTDEC:
	call printDec
	br INCREMENT

INCREMENT:
	addi r23, r23, 1
	addi r17, r17, 4
	br LOOP

ENDLOOP:
ldw r23, 32(sp) 
ldw r22, 28(sp)
ldw r21, 24(sp)
ldw r20, 20(sp)
ldw r19, 16(sp)
ldw r18, 12(sp)
ldw r17, 8(sp)
ldw r16, 4(sp)
ldw r5, 36(sp)
ldw r6, 40(sp)
ldw r7, 44(sp)
ldw ra, 0(sp) 
addi sp,sp, 48
ret
	




	