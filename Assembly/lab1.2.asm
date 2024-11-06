.data

ask_int: .asciiz "Give me a integer\t"
out: .asciiz "Hello World! "

.text

main:

li $v0, 4
la $a0, ask_int
syscall

li $v0, 5
syscall

add $t0, $v0, $0

li $v0, 4 
la $a0, out 
syscall

add $a0, $t0, $t0

li $v0, 1 
syscall

li $v0, 10
syscall