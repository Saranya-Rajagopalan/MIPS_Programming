########################################################
# C Program to be written in MIPS for reference
# -----------------------------------------------------
# int sum = 0; int *sumPtr = &sum;
# int array[10];
# void updateSum(int *total, int *element)
# {
#     *total += *element;
# }
# int main()
# {
#     for (int i=0; i<10; i++)
#         array[i] = 2*(i+1);
#     for (int i=0; i<10; i++)
#         updateSum(sumPtr, array+i);
#     printf("Sum = %d", sum);
# } 
#-------------------------------------------------------
# t0-t9 are used in the procedure calls because according
# to general convention the values in temporary registers
# are not preserved during function calls. So the values
# need not be saved in stack before using as local
# variables of the procedure.
########################################################

########################################################
#	data
########################################################
.data
total: .word 0
array: .word 0 : 10


########################################################
#	Text
########################################################

.text
	.globl main
	# int sum = 0; int *sumPtr = &sum;
	la $s1, array		        # save the base address of the array in $s1
	la $s0, total			# save the address of total in $s0
	
	
main:	li $t0, 0		        # initialize the index
loop:	beq $t0, 10, exit_loop	 	# Check exit condition: quit loop if the last element is reached
	sll $t2, $t0, 2		        # multiply the index by 4 to get the memory address. sll is faster than mul
	add $t2, $t2, $s1	 	# find the effective address of each element
	addi $t0, $t0, 1	       	# increment index 
	sll $t1, $t0, 1		     	# multiply the incremented value by 2(shift left once = multiply by2)
	sw $t1, 0($t2)			#store the value in $t1 to the word
	j loop
exit_loop:
	li $t0, 0			# initialize the index again for the second for loop
	move $a0, $s0			# save the address of total variable in first argument
loop2:	beq $t0, 10, exit_loop2 	# if the index goes out of bounds exit loop
	sll $t2, $t0, 2			# multiply index by 2
	add $a1, $t2, $s1		# find effective address and save it in $a1
	addi $t0, $t0, 1		# update index
	jal updateSum			# call  updateSum method by using jump and link
	j loop2				# repeat for the next element
	
exit_loop2:
	li $v0, 1			# system call to print integer
	lw $a0, 0($a0)			# obtain the word stored in $a0 to be printed
	syscall
	j exit	 



updateSum:
	# $a0 contains the address of total
	# $a1 contains the address of the array element
	lw $t6, 0($a0)		#load the value stored in addresses
	lw $t7, 0($a1)
	add $t6, $t6, $t7	# total = total + element
	sw $t6, 0($a0)		# save the value back in total's address
	jr $ra			# return
	
exit:   li $v0, 10		#sys_exit
	syscall

