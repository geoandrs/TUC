.data

operation: 	 .asciiz "Give me the operation\n"
num1: 		 .asciiz "Give me the first number\n"
num2: 		 .asciiz "\nGive me the second number\n"
result: 	 .asciiz "\nThe result is:\t"
error_mes:	 .asciiz "\nYou can't divide with zero"
error_op:	 .asciiz "\nInvalid operation"

.text	

main:

##  Read first number

		li $v0, 4
		la $a0, num1
		syscall

		li $v0, 5
		syscall

		add $t0, $v0, $zero	## Save first number


##  Read operation

		li $v0, 4
		la $a0, operation
		syscall
		
		li $v0, 12
		syscall
		
		add $t2, $v0, $zero ## Save operation
		
##  Read second number

		li $v0, 4 
		la $a0, num2
		syscall

		li $v0, 5
		syscall

		add $t1, $v0, $zero	## Save second number


		li $t3, 43
		beq $t2, $t3, addition

		li $t3, 45
		beq $t2, $t3, subtraction
		
		li $t3, 42
		beq $t2, $t3, multiplication
		
		li $t3, 47
		beq $t2, $t3, division
		
		j op_error



addition:
		add $t0, $t0, $t1
		j out
subtraction:
		sub $t0, $t0, $t1
		j out
multiplication:
		mul $t0, $t0, $t1
		j out
division:
		beq $t1, $zero, error
		div $t0, $t0, $t1
		j out


out:
		li $v0, 4
		la $a0, result
		syscall
		
		move $a0, $t0
		li $v0, 1
		syscall

		li $v0, 10
		syscall
		
error:
		li $v0, 4
		la $a0, error_mes
		syscall
		
		li $v0, 10
		syscall
		
op_error:
		li $v0, 4
		la $a0, error_op
		syscall
		
		li $v0, 10
		syscall