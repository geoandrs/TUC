.data
str1: .asciiz "\nPlease enter a number in the range 0-24, or Q to quit:\n"
str2: .asciiz "This number is outside the allowable range.\n"
str3: .asciiz "\nThe Fibonacci number F   is "
str4: .asciiz "\nInput error"
.align 2
buffer: .space 4

.text

main:
	
	la $t0, buffer
	sw $zero, 0($t0)
	
	li $v0, 4
	la $a0, str1
	syscall
	
	li $v0, 8
	la $a0, buffer
	li $a1, 4
	syscall
	
	la $a1, str3
	
	jal check_entry
	
	move $t0, $v0
	move $t1, $v1
	
	li $t2, -1
	beq $t0, $t2, terminate
	
	li $t2, -2
	beq $t0, $t2, main
	
	li $t2, 25
	slt $t2, $t0, $t2
    beq $t2, $zero, error
	
	move $a0, $t0
	jal fibonacci
	move $t0, $v0
	
	li $v0, 4
	la $a0, str3
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	j main
	
	error:
	
	li $v0, 4
	la $a0, str2
	syscall
	j main
	
	terminate:
	
	li $v0, 10
	syscall

	
check_entry:
	
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	
	lb $t0, 0($a0)
	li $t1, 48                              # Check if the 
    slt $t1, $t0, $t1                       # char is a number
    bne $t1, $zero, input_error
    li $t1, 57 
	slt $t1, $t1, $t0
	bne $t1, $zero, q_check
	addi $t1, $t0, -48
	add $t2, $t2, $t1
	li $t1, 10
	mul $t2, $t2, $t1
	j store
	
	byte2:
	
	lb $t0, 1($a0)
	li $t1, 10
	bne $t0, $t1, check_second_byte
	div $t2, $t2, $t1
	move $v0, $t2
	li $t0, 32
	sb $t0, 23($a1)
	j return
	
	check_second_byte:
	
	li $t1, 48                              # Check if the 
    slt $t1, $t0, $t1                       # char is a number
    bne $t1, $zero, input_error
    li $t1, 57 
	slt $t1, $t1, $t0
	bne $t1, $zero, q_check
	addi $t1, $t0, -48
	add $t2, $t2, $t1
	addi $t3, $zero, 1
	j store
	
	q_check:
	
	li $t1, 81
	bne $t0, $t1, input_error
	li $v0, -1
	j return
	
	input_error:
	
	li $t1, 2
	beq $t3, $t1, return
	li $v0, 4
	la $a0, str4
	syscall
	li $v0, -2
	j return
	
	store:
	
	sb $t0, 23($a1)
	addi $a1, $a1, 1
	li $t1, 1
	bne $t3, $t1, byte2
	move $v0, $t2
	
	return:
	move $v1, $a1
	jr $ra
	
fibonacci:
	
	li $t0, 1
	slt $t0, $t0, $a0
	beq $t0, $zero, fib_exit
	
	addi $sp, $sp, -12 
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	addi $a0, $a0, -1
	jal fibonacci
	lw $a0, 4($sp)
	sw $v0, 8($sp)
	
	addi $a0, $a0, -2
	jal fibonacci
	
	lw $t0, 8($sp)
	add $v0, $t0, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 12 
	jr $ra
	
	fib_exit:
	
	move $v0, $a0
	jr $ra
	
	