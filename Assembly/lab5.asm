.data
entry_message: 		.asciiz "\nPlease enter a number in the range 0-24, or Q to quit:\n"
entry_error: 		.asciiz "\nThis number is outside the allowable range.\n"
fib_out: 			.asciiz "\nThe Fibonacci number F   is "
wrong_input: 		.asciiz "\nInput error"
.align 2
buffer: 			.space 3

.text

main:
	
	la $t0, buffer
	sw $zero, 0($t0)					# clear buffer to add a new value
	
	li $v0, 4
	la $a0, entry_message				# ask and take a string from user
	syscall
	
	li $v0, 8
	la $a0, buffer
	li $a1, 3
	syscall
	
	la $a1, fib_out
	
	jal check_entry						# function to check the entry and 
										# and complete the fib_out string
	move $t0, $v0						# move the return values to $t registers
	move $t1, $v1
	
	li $t2, -1							# check if the user want to terminate
	beq $t0, $t2, terminate				# the program, if entry = Q then check_entry
										# return -1	
	li $t2, -2							# if user give me wrong input then 
	beq $t0, $t2, main					# check entry return -2
	
	li $t2, 26							# check if the number of input is
	slt $t2, $t0, $t2					# less than 25
    beq $t2, $zero, error
	
	move $a0, $t0						# save in stack the argument $a0
	addi $sp, $sp, -4 					# and call the function fibonacci
	sw $a0, 0($sp)
	jal fibonacci
	lw $t0, 0($sp)						# take from stack the return value
	addi $sp, $sp, 4					# of fibonacci function
	
	li $v0, 4							# print with 2 syscall the
	la $a0, fib_out						# right message and the value
	syscall								# calculated from the function
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	j main								# return to main
	
	error:
	
	li $v0, 4							# print the error message
	la $a0, entry_error
	syscall
	j main
	
	terminate:
	
	li $v0, 10							# terminate the program
	syscall
	
check_entry:
	
	add $t2, $zero, $zero				# 2 counters
	add $t3, $zero, $zero
	
	lb $t0, 0($a0)
	li $t1, 48                          # Check if the first byte
    slt $t1, $t0, $t1                   # is a number and store it
    bne $t1, $zero, input_error
    li $t1, 57 
	slt $t1, $t1, $t0
	bne $t1, $zero, q_check
	addi $t1, $t0, -48					# from ascii to decimal we have to 
	add $t2, $t2, $t1					# add -48
	li $t1, 10							# we multiply with 10 because we want 
	mul $t2, $t2, $t1					# the second byte to be stored next to the first
	j store								# ex. if we have 24, we read 2, the multiply
										# with 10 and we have 20 so when we read the second
	byte2:								# byte (4) we will add it to this value (20+4=24)
	
	lb $t0, 1($a0)						# check if the second byte is \n, if yes we divide with 10
	li $t1, 10							# to have the 1 byte input
	bne $t0, $t1, check_second_byte		# and store in the fib_out string a space in
	div $t2, $t2, $t1					# this place
	move $v0, $t2
	li $t0, 32
	sb $t0, 23($a1)
	j return
	
	check_second_byte:
	
	li $t1, 48                           # Check if the second byte
    slt $t1, $t0, $t1                    # is a number and store it
    bne $t1, $zero, input_error
    li $t1, 57 
	slt $t1, $t1, $t0
	bne $t1, $zero, input_error
	addi $t1, $t0, -48
	add $t2, $t2, $t1
	addi $t3, $zero, 1
	j store
	
	q_check:
	
	li $t1, 81							# check if the entry is Q and return
	bne $t0, $t1, input_error			# -1
	li $v0, -1
	j return
	
	input_error:
	
	li $t1, 2							# if we have something but not a number
	beq $t3, $t1, return				# or Q we print the right message 
	li $v0, 4							# and return to main loop with value -2
	la $a0, wrong_input
	syscall
	li $v0, -2
	j return
	
	store:
	
	sb $t0, 23($a1)						# store byte to fib_out string
	addi $a1, $a1, 1
	li $t1, 1
	bne $t3, $t1, byte2
	move $v0, $t2
	
	return:
	move $v1, $a1						# return to main
	jr $ra
	
fibonacci:

	lw $a0, 0($sp)						# take the argument from stack
	addi $sp, $sp, 4					# adjust stack size
	
	li $t0, 1							# check if the argument is 0 or 1
	slt $t0, $t0, $a0					# if yes exit from the function
	beq $t0, $zero, fib_exit
	
	addi $sp, $sp, -12					# adjust stack size for 3 values
	sw $ra, 0($sp)						# save return address
	sw $a0, 4($sp)						# save the basic argument because we need it later
	addi $a0, $a0, -1					# decrease the argument value by 1
	addi $sp, $sp, -4 					# adjust stack size for 1 more item
	sw $a0, 0($sp)						# save the new argument
	jal fibonacci						# call the function
	lw $v0, 0($sp)						# take the return value
	addi $sp, $sp, 4 					# adjust stack size
	lw $a0, 4($sp)						# take the basic argument
	sw $v0, 8($sp)						# save the return value
	
	# we use the stack this way because we want to have in the 0 place the argument of the function
	# so we adjust stack pointer to take and return arguments in 0 place without change the value
	# of the other variables we have to save in the stack
	
	addi $a0, $a0, -2					# decrease the argument value by 2
	addi $sp, $sp, -4 					# adjust stack size for 1 more item
	sw $a0, 0($sp)						# save the new argument
	jal fibonacci						# call the function
	lw $v0, 0($sp)						# take the return value
	addi $sp, $sp, 4					# adjust stack size
	
	lw $t0, 8($sp)						# load the first saved return value
	add $v0, $t0, $v0					# add the 2 return values
	
	lw $ra, 0($sp)						# restore the return address
	addi $sp, $sp, 12					# adjust stack size
	addi $sp, $sp, -4 					# adjust stack size
	sw $v0, 0($sp)						# save return value
	jr $ra								# return to main
	
	fib_exit:
	
	move $v0, $a0						# when argument is 0 or 1
	addi $sp, $sp, -4 					# adjust stack size
	sw $v0, 0($sp)						# save the value to return
	jr $ra								# return to main
	