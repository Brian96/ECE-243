# Include nios_macros.s to workaround a bug in the movia pseudo-instruction.
.include "nios_macros.s"

.equ RED_LEDS, 0x10000000
.equ GREEN_LEDS, 0x10000010     # (Hint: See DESL website for documentation on LEDs)

.data                  # "data" section for input and output lists

IN_LIST:               # List of 10 words starting at location IN_LIST
    .word 1
    .word -1
    .word -2
    .word 2
    .word 0
    .word 5
    .word 100
    .word 0xffffff9c
    .word 0x10
    .word 0b1111
    
OUT_NEGATIVE:
    .skip 40            # Reserve space for 10 output words
    
OUT_POSITIVE:
    .skip 40            # Reserve space for 10 output words

#-----------------------------------------

.text                  # "text" section for (read-only) code

  
.global _start
_start:

	movia r6,IN_LIST
	movia r7, OUT_NEGATIVE
	movia r8, OUT_POSITIVE
	movi r2, 0					# initialize counter for negative
	movi r3, 0 					# initialize counter for positive
	movi r13, 0					# initialize counter for IN_LIST
	movi r11, 10				# set length of the array
	
	LOOP:
	bge r13,r11, LOOP_FOREVER			# test for end of array

	ldw r12, 0(r6)				# load number from array: IN_LIST

	bge r12, r0, POSLIST		# enter br POSLIST, other enter the following statement

	addi r2,r2,1
	stw r12, 0(r7)				# storing the element from IN_LIST into OUT_NEGATIVE
	addi r7,r7,4				# increment the address for neg list		
	br INCREMENT_ADD

	POSLIST:
	addi r3,r3,1				# incrementing the pos list counter
	stw r12, 0(r8)				# storing the element from IN_LIST into OUT_POSITIVE
	addi r8,r8,4				# increment the address for pos list
	
	INCREMENT_ADD:
	addi r13, r13, 1
	addi r6, r6, 4				# have to increment the address of IN_LIST in either case
	movia  r16, RED_LEDS          # r16 is a temporary value
    stwio  r2, 0(r16)             # Send r2 out to the red LEDs device
    movia  r16, GREEN_LEDS
    stwio  r3, 0(r16)             # Send r3 out to the green LEDs device
	
	LOOP_FOREVER:
    br LOOP               # Loop forever.
	
	
	
	.end
	
	
	
		  # Register allocation:
    #   r0 is zero, and r1 is "assembler temporary". Not used here.
    #   r2  Holds the number of negative numbers in the list
    #   r3  Holds the number of non-negative numbers in the list
    #   r_  A pointer to ___
    #   r_  loop counter for ___
    #   r16 Register for short-lived temporary values.
    #   etc...

    # Your program here. Pseudocode and some code done for you:
    
    # Begin loop to process each number
    
        # Process a number here:
        #    if (number is negative) { 
        #        insert number in OUT_NEGATIVE list
        #        increment count of negative values (r2)
        #    } else {
        #        insert number in OUT_POSITIVE list
        #        increment count of non-negative values (r3)
        #    }
        # Done processing.
        
		
		
		
		
		
		
		
		
		
		
		
        # After processing each number, output current counts to LEDs.
        # (You'll learn more about I/O in Lab 4.)
        # Finished output to LEDs.
        
    # End loop

