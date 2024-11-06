.data

operation: 	 .asciiz "\nGive me the operation\n"
num1: 		 .asciiz "Give me the first number\n"
num2: 		 .asciiz "\nGive me the second number\n"
LSB: 	     .asciiz "\nThe LSB is:\t"
error_mes:	 .asciiz "\nYou can't divide with zero"
error_op:	 .asciiz "\nInvalid operation"
error_ch:    .asciiz "\nInvalid hex number"

.text	

main:
		li $v0, 4
		la $a0, num1
		syscall

		li $v0, 12											## Read first number
		syscall

		add $t0, $v0, $zero									## Save first number

		li $t4, 48											#	Check if the 
		slt $t4, $t0, $t4									# 	number 1 is between
		bne $t4, $zero, char_error							#	ascii 48-57 
		li $t4, 57											#	and convert it 
		slt $t4, $t4, $t0 									#	to integer
		bne $t4, $zero, A_Znum1								#
		addi $t0, $t0, -48									#
		j read_operation
		
A_Znum1:
		li $t4, 65											#	Check if the
		slt $t4, $t0, $t4									#	number 1 is between
		bne $t4, $zero, char_error							#	ascii 65-70
		li $t4, 70											#	and convert it
		slt $t4, $t4, $t0 									#	to integer
		bne $t4, $zero, char_error							#
		addi $t0, $t0, -55									#
		
read_operation:	
		li $v0, 4
		la $a0, operation
		syscall
			
		li $v0, 12											##  Read operation
		syscall
		
		add $t2, $v0, $zero									## Save operation
		

		li $v0, 4 
		la $a0, num2
		syscall

		li $v0, 12											##  Read second number
		syscall

		add $t1, $v0, $zero									## Save second number

		li $t4, 48											#	Check if the
		slt $t4, $t1, $t4									#	number 2 is between
		bne $t4, $zero, char_error							#	ascii 48-57
		li $t4, 57											#	and convert it
		slt $t4, $t4, $t1 									#	to integer
		bne $t4, $zero, A_Znum2								#
		addi $t1, $t1, -48									#
		j equations
		
A_Znum2:
		li $t4, 65											#	Check if the
		slt $t4, $t1, $t4									#	number 2 is between
		bne $t4, $zero, char_error							#	ascii 65-70
		li $t4, 70											#	and convert it
		slt $t4, $t4, $t1 									#	to integer
		bne $t4, $zero, char_error							#
		addi $t1, $t1, -55									#
		
equations:
		li $t3, 43
		beq $t2, $t3, addition								## If operation is +

		li $t3, 45
		beq $t2, $t3, subtraction							## If operation is -
		
		li $t3, 42
		beq $t2, $t3, multiplication						## If operation is *
		
		li $t3, 47
		beq $t2, $t3, division								## If operation is /
		
		j operation_error



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


out:														## Print the result of every operation
		li $v0, 4
		la $a0, LSB
		syscall
		
		li $t1, 16
		rem $t0, $t0, $t1									## Take the LSB as an integer
		
		li $t1, 10											#	Check if 
		slt $t1, $t0, $t1									#	the LSB is between
		bne $t1, $zero, L1									#	10-15 and convert
		addi $t0, $t0, 55									#	it to char
		j L2
	L1:
		addi $t0, $t0, 48									#	Else is between 0-10 and convert to char
		
	L2:
		move $a0, $t0
		li $v0, 11
		syscall

		li $v0, 10
		syscall
		
error:														## Divide with zero error
		li $v0, 4
		la $a0, error_mes
		syscall
		
		li $v0, 10
		syscall
		
operation_error:											## Invalid operation error
		li $v0, 4
		la $a0, error_op
		syscall
		
		li $v0, 10
		syscall
		
char_error:
		li $v0, 4
		la $a0, error_ch
		syscall
		
		li $v0, 10
		syscall 