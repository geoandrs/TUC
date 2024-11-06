.data

input_string: .asciiz "Please Enter your String:\t"
.align 2
buffer_in: .space 100
buffer_out: .space 100

.text

main:
	
	add $t5, $zero, $zero					# use two register as flag
	add $t6, $zero, $zero					# second is for not printing a space first
	la $s0, buffer_out						# pointer - register for save
	
	li $v0, 4								# ask for a string
	la $a0, input_string					# the first function 
	syscall
	
	li $v0, 8								# read user string 
	la $a0, buffer_in						# and save it in a temporal
	li $a1, 100								# register because I use it all the time
	move $t0, $a0
	syscall

load_word:
	
	lw $t1, 0($t0)							# 
	beq $t1, $zero, out						# 
	addi $t0, $t0, 4						# labels load_word and mask is
											# two loops one inside the other
mask:										# to read a word from user's string
											# and get the first byte of this
	andi $t3, $t1, 0xFF						# and then call the function
	beq $t3, $zero, load_word				# read_char
	jal read_char							#
	j mask									#
	
out:
	
	li $v0, 4								# the function for printing the
	la $a0, buffer_out						# final string
	syscall
	
	li $v0, 10								# terminate the program
	syscall 
	
read_char:									# the main function of the program
	
	srl $t1, $t1, 8							# swift right to get a new byte from the word
	
	li $t4, 10								# check if the char is the '\n'
	beq $t3, $t4, store_byte
	
	li $t4, 48                              # Check if the 
    slt $t4, $t3, $t4                       # char is a number
    bne $t4, $zero, another_char                           
    li $t4, 57 
	slt $t4, $t4, $t3
	bne $t4, $zero, A_Z
	add $t5, $zero, $zero
	addi $t6, $zero, 1
	j store_byte

	A_Z:

    li $t4, 65                              # check if the    
    slt $t4, $t3, $t4                       # char is between
    bne $t4, $zero, another_char            # A-Z and convert it
    li $t4, 90                              # to a-z
    slt $t4, $t4, $t3
    bne $t4, $zero, a_z
    addi $t3, $t3, 32
	add $t5, $zero, $zero
	addi $t6, $zero, 1
	j store_byte

	a_z:

    li $t4, 97                   			# check if the
    slt $t4, $t3, $t4            			# char is between
    bne $t4, $zero, another_char  			# a-z
    li $t4, 122
    slt $t4, $t4, $t3
    bne $t4, $zero, another_char
	add $t5, $zero, $zero
	addi $t6, $zero, 1
	j store_byte
	
	another_char:							# if all checks is false
											# then the char is an unwanted
	beq $t6, $zero, exit_of_function		# char. So in the first time 
	bne $t5, $zero, exit_of_function		# I find one I convert it to 
	addi $t3, $zero, 32						# a 'space' and the I change the flag
	addi $t5, $t5, 1						# until I find a number or a letter
	
	store_byte:								# the label that stores a byte and
											# move the pointer in the next 
	sb $t3, 0($s0)							# byte
	addi $s0, $s0, 1
	
	exit_of_function:						# the label for the exit of the read_char
											# function and return to the main two loops 
	jr $ra
	