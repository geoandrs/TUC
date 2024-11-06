.data

ask_char: .asciiz "Give me a char\t"
out: .asciiz "\nHello World! "

.text

main:

li $v0, 4
la $a0, ask_char
syscall

li $v0, 12
syscall

move $t0, $v0

li $v0, 4 
la $a0, out 
syscall

move $a0, $t0

li $v0, 11 
syscall

li $v0, 10
syscall