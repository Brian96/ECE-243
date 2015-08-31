# Print ten in octal, hexadecimal, and decimal
# Use the following C functions:
#     printHex ( int ) ;
#     printOct ( int ) ;
#     printDec ( int ) ;

.global main

main:
# ...
	movi r4, 10	
	call printOct
	movi r4, 10
	call printHex
	movi r4, 10
	call printDec

  ret
