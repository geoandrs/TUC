.data

buffer: .space 10					
ask_string: .asciiz "Give me a string (max 10 char)\t"
##	if less than 10 then \n in the end of string
##	without buffer \n for every string
out1: .asciiz "\nHello "
out2: .asciiz " World!"

.text	

main:

li $v0, 4
la $a0, ask_string
syscall

li $v0, 8
la $a0, buffer
li $a1, 10
syscall
move $t0, $a0
	
li $v0, 4 
la $a0, out1 
syscall

la $a0, buffer
move $a0, $t0
syscall
 
la $a0, out2 
syscall

li $v0, 10
syscall