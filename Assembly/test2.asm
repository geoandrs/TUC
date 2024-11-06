.data

num: .space 8

.text

main:
la $t0, num

li $v0, 5
syscall
sb $v0, 0($t0)

li $v0, 5
syscall
sb $v0, 1($t0)

la $a0, num
li $v0, 4
syscall 


li $v0, 10
syscall 