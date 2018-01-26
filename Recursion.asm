##########################################################################
# C Program converted into MIPS
# int compute (int i, int x)
# {
# if (x>0)
# 	return compute(i, x-1) + 1;
# else if (i>0)
# 	return compute(i-1, i-1) + 5;
# else 
#	return 1;
# }
##########################################################################

########################################################
#	data
########################################################	
.data

# Create some null terminated strings to use
strPromptFirst:		 .asciiz "Enter a value for i: " 
strPromptSecond:	 .asciiz "Enter a value for x: " 
strResult:	 	 .asciiz "Result  is  " 
strCR:			 .asciiz "\n" 


########################################################
#	Text
########################################################

.text
		.globl main
main:
		# STEP 1 -- get the first operand
		# Print a prompt asking user for input
		li $v0, 4   		# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptFirst  # "load address" of the string
		syscall     		# actually print the string  
		li $v0, 5      		# syscall number 5 will read an int
		syscall        		# read the int
		move $s0, $v0  		# save result in $s0 for later
		
		# STEP 2 -- get the second operand
		# Print a prompt asking user for input
		li $v0, 4   		# syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptSecond  # "load address" of the string
		syscall     		# actually print the string  
		li $v0, 5      		# syscall number 5 will read an int
		syscall        		# read the int
		move $s1, $v0  		# save result in $s0 for later
				
		move $a1,$s1		# save i and x in the two argument registers
		move $a0, $s0
		jal compute
		move $s1, $v0

		# STEP 3 -- print the sum
		li $v0, 4      		# syscall number 4 -- print string
	        la $a0, strResult   
	        syscall        		# actually print the string   
	        li $v0, 1         	# syscall number 1 -- print int
	        move $a0, $s1   	# add our operands and put in $a0 for print
	        syscall           	# actually print the int

		# STEP 4 -- exit
		li $v0, 10  		# Syscall number 10 is to terminate the program
		syscall     		# exit now


compute:		
		addi $sp, $sp, -12	# adjust the stack pointer to accommodate 3 values
		sw   $ra, 0($sp)	# save the return address in stack pointer
		bgtz $a1,if		# if x > 0, go to if
		bgtz $a0,else_if	# if i >0, go to else_if
	else:	li   $v0, 1		# added a dummy label for clarity. This happens if both of the above conditions fail and we return 1
		lw   $ra, 0($sp)	# retrieve data from the stack
		addi $sp, $sp, 12	# update the stack pointer
		jr   $ra 		# jump to return address
		
	if:	
		sw     $a1, 4($sp)	# save the argument in stack pointer before calling the procedure again
		add   $a1, $a1, -1	# decrement x
		jal     compute		# call function again wtih new arguments
		addi  $v0,$v0,1		# add 1 to the return value
		lw $ra, 0($sp)		# retrieve data from teh stack pointer
		addi $sp, $sp, 12	# update stack
		jr $ra 			# return
      else_if:	
		sw     $a0, 8($sp)	# save the argument in stack
		add   $a0, $a0, -1	# update argument
		move $a1, $a0		
		jal     compute		# recursively call compute again
		addi  $v0,$v0,5		# add 5 to the return value
		lw $ra, 0($sp)		# retrieve the return address from stack
		addi $sp, $sp, 12	# update stack pointer
		jr $ra			# return 
