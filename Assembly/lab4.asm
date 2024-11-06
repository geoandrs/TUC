.data

print_numtab: 			.asciiz		".\t"
print_inquiry:			.asciiz		"\nPlease enter the entry number you wish to retrieve:\n"
operation_input: 		.asciiz 	"Please determine operation, entry (E), inquiry (I) or quit (Q):\n"
last_name_input: 		.asciiz 	"\nPlease enter last name:\n"
first_name_input: 		.asciiz 	"Please enter first name:\n"
phone_number_input: 	.asciiz 	"Please enter phone number:\n"
new_entry_message: 		.asciiz 	"Thank you, the new entry is the following:\n"
no_entry_message: 		.asciiz 	"There is no such entry in the phonebook\n"
number_find: 			.asciiz 	"The number is:\n"
full_message:			.asciiz		"The phonebook is full!\n"
.align 2
phonebook: 				.space 		600
print:					.space 		60
buffer:					.space		20

.text

main:
	
	la $s0, phonebook						# pointer in the phonebook
	li $s1, 0								# global variable 
	
	main_loop:								# is used for a continous flow
	
	jal prompt_user							# the function to get user's choice
	move $t0, $v0							# move it to t0 because i will use v0 for syscalls
	
	add $a0, $s0, $zero						# a copy of pointer used as argument in functions 
	
	li $t1, 69								# E=69 
	beq $t0, $t1, ckeck_flag				# check if user input is E 
	j other_checks							# if not go to check the other possible values of user input
	ckeck_flag:
	li $t1, 10
	bne $s1, $t1, read_function				# check if phonebook is full, if it has 10 entries
	j full_phonebook						# if phonebook is full print the right message
	
	other_checks:
	li $t1, 73								# I=73 
	beq $t0, $t1, print_function			# check if user input is I
	li $t1, 81								# Q=81 
	beq $t0, $t1, terminate					# check if user input is Q
	j main_loop
	
	read_function:
	
	addi $s1, $s1, 1						# call the function get_entry with 2 arguments 
	addi $a1, $s1, -1						# a0 = pointer to the memory (600) a1 = number of entries
	jal get_entry
	move $t0, $v0
	li $v0, 4
	la $a0, new_entry_message				# print a success message for the new entry
	syscall
	move $a0, $t0							# call the function print_loop with 2 arguments
	add $a3, $s1, $zero						# a0 = the return value of the function get_entry
	jal print_loop							# a3 = number of entries
	j main_loop
	
	print_function:
	
	addi $a0, $s0, 0						# call the function print_entry with 2 arguments
	add $a1, $s1, $zero						# a0 = pointer to the memory (600) a1 = number of entries
	jal print_entry
	j main_loop
	
	full_phonebook:							# the label to print the right message
											# if phonebook is full
	li $v0, 4
	la $a0, full_message
	syscall
	j main_loop
	
	terminate:
	
	li $v0, 10								# terminate the program
	syscall 
	
prompt_user:
	
	li $v0, 4								# ask the user what he want to do
	la $a0, operation_input
	syscall

	li $v0, 12								# get a char as a response
	syscall

	jr $ra									# get back in main
	
get_entry:
	
	addi $sp, $sp, -8						# adjust stack size for 2 more items
	sw $ra, 0($sp)							# save return address
	sw $s0, 4($sp)							# save the register s0

	move $t0, $a0
	move $t1, $a1
	
	li $t2, 60								# a part of the function to calculate
	mul $t2, $t2, $t1						# where in the memory (600) I have to put 
	add $t0, $t0, $t2						# the new entry
	add $s0, $t0, $zero						# example: if the entries are 4 I have to start
	move $a2, $s0							# saving the new entry from 5*60=300
	
	jal get_last_name						# get the last name and move the pointer 20 bytes
	addi $a2, $a2, 20
	
	jal get_first_name						# get the first name and move the pointer 20 bytes
	addi $a2, $a2, 20

	jal get_number							# get the number
	
	move $v0, $s0							# return a pointer in the new entry
	
	lw $s0, 4($sp)							# restore s0
	lw $ra, 0($sp)							# and return address
	addi $sp, $sp, 8						# adjust stack size
	jr $ra									# return to main
	
print_entry:

	addi $sp, $sp, -4						# adjust stack size for 2 more items
	sw $ra, 0($sp)							# save return address
	
	
	move $t0, $a0
	move $t1, $a1
	
	li $v0, 4
	la $a0, print_inquiry
	syscall

	li $v0, 5								# ask the user which entry he/she want to print
	syscall
	move $t2, $v0
	move $a3, $t2
	
	slt $t4, $t1, $t2						# and check if I have as entries he/she told me to print
    bne $t4, $zero, error_inquiry 
	
	li $t3, 60								# a part of the function to calculate
	addi $t2, $t2, -1						# where in the memory (600) I have to start
	mul $t3, $t3, $t2						# printing
	add $t0, $t0, $t3
	
	move $a0, $t0							# call the function print_loop
	jal print_loop							# a0 = the value of the calculation above
	j print_exit							# a3 = number of the entry he/she want to print
	
	error_inquiry:
	li $v0, 4								# print the right message if I don't have 
	la $a0, no_entry_message				# so many entries
	syscall
	
	print_exit:
	lw $ra, 0($sp)							# and return address
	addi $sp, $sp, 4						# adjust stack size
	jr $ra									# return to main
	
get_last_name:
	
	addi $sp, $sp, -4						# adjust stack size for 2 more items
	sw $ra, 0($sp)							# save return address
	
	li $v0, 4
	la $a0, last_name_input
	syscall									# ask and get last name
	
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	syscall
	jal store_string						# call the function to store last name in memory 
	
	lw $ra, 0($sp)							# and return address
	addi $sp, $sp, 4						# adjust stack size
	jr $ra									# return
	
get_first_name:
	
	addi $sp, $sp, -4						# adjust stack size for 2 more items
	sw $ra, 0($sp)							# save return address
	
	li $v0, 4
	la $a0, first_name_input
	syscall									# ask and get first name
	
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	syscall
	jal store_string						# call the function to store first name in memory 
	
	lw $ra, 0($sp)							# and return address
	addi $sp, $sp, 4						# adjust stack size
	jr $ra									# return

get_number:
	
	addi $sp, $sp, -4						# adjust stack size for 2 more items
	sw $ra, 0($sp)							# save return address
	
	li $v0, 4
	la $a0, phone_number_input
	syscall									# ask and get number
	
	li $v0, 8
	la $a0, buffer
	li $a1, 20
	syscall
	jal store_string						# call the function to store number in memory 

	lw $ra, 0($sp)							# and return address
	addi $sp, $sp, 4						# adjust stack size
	jr $ra									# return
	
store_string:
	
	move $t2, $a2
	move $t0, $a0
	add $t3, $zero, $zero
	
	loop1:									# use lw-sw because I want to store 20
	addi $t3, $t3, 1						# bytes in 60 bytes space
	lw $t1, 0($t0)							# and I need only 5 times on the loop
	addi $t0, $t0, 4
	sw $t1, 0($t2)
	addi $t2, $t2, 4
	li $t4, 5
	bne $t3, $t4, loop1
	
	la $t6, buffer							# I have to clear the memory of the buffer to
	add $t3, $zero, $zero					# store the next string
	loop4:									# so I use the same loop as above
	addi $t3, $t3, 1
	sw $zero, 0($t6)
	addi $t6, $t6, 4
	li $t4, 5
	bne $t3, $t4, loop4
	jr $ra									# return
	
print_loop:
	
	move $t0, $a0
	move $t7, $a3
	la $t1, print
	li $t4, 2
	li $t5, 0
	
	loop2:
	lb $t2, 0($t0)							# in this function I can't use lw-sw
	addi $t0, $t0, 1						# because I want to find the new line char = \n
	li $t3, 10								# and replace it with a space only for the name,
	beq $t2, $t3, add_space					# not for the number, so I have to use lb-sb
	li $t3, 0
	beq $t2, $t3, loop2
	sb $t2, 0($t1)
	addi $t1, $t1, 1
	j loop2
	
	add_space:
	beq $t4, $t5, store_enter				# the label to transform \n to space
	addi $t5, $t5, 1						# and store it to memory
	li $t2, 32
	sb $t2, 0($t1)
	addi $t1, $t1, 1
	j loop2
	
	store_enter:
	sb $t2, 0($t1)							# in the end of the number
	addi $t1, $t1, 1						# I store the only enter I need
	sb $zero, 0($t1)
	
	li $v0, 1								# in this section of the code 
	move $a0, $t7							# I print the number of entry I'm printing now
	syscall									# and a '.tab'
	li $v0, 4								# and then the entry
	la $a0, print_numtab
	syscall
	li $v0, 4
	la $a0, print
	syscall
	
	la $t6, print							# like the buffer I have to clear and the
	add $t3, $zero, $zero					# space of print before printing nothing else
	loop3:
	addi $t3, $t3, 1
	sw $zero, 0($t6)
	addi $t6, $t6, 4
	li $t4, 16
	bne $t3, $t4, loop3
	jr $ra									# return
