 .equ ADDR_7SEG1, 0x10000020
 .equ ADDR_7SEG2, 0x10000030

.global _start

_start:

  # Display when user presses enter
  # movia r2,ADDR_7SEG1
  # movia r3,0b0111111001111110011111100111111   /* bits 0000110 will activate segments 1 and 2 */
  # stwio r3,0(r2)        /* Write to 7-seg display */
  # movia r2,ADDR_7SEG2
  # stwio r3, 0(r2)


  # movia r2, ADDR_7SEG2
  # movia r3, 0b1110011011110010101000001110001
  # stwio r3, 0(r2)
  # movia r2, ADDR_7SEG1
  # movia r3, 0b1111001001110010111100000001000
  # stwio r3, 0(r2)
  
 
  movia r2, ADDR_7SEG2
  movia r3, 0b1101110001111110011111000000000
  stwio r3, 0(r2)
  movia r2, ADDR_7SEG1
  movia r3, 0b0111000001111110110110101111001
  stwio r3, 0(r2)
  
 
 
 
 
 
 
 
 end:
  br end 