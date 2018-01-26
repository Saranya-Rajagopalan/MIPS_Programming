##################################################################
# OBJECTIVE:
#	To convert a string into upper case.
#
# PSEUDOCODE:
# index = 0
# t = string[index]
# while(t!=NULL)
# 	if(97<=t<=122)
#		t =t-122
#	string[index] =t
#	index = index +1
#	t = string[index]
##################################################################



##################################################################
#	data segment
##################################################################
.data
# declaring a null terminated string
string: .asciiz "Welcome to Computer Architecture Class!\n"

#################################################################
#	TEXT
#################################################################
.text
		.globl main
main:		li $t0, 0		# initialize the index to 0
		
loop:		lb $t1, string($t0)
		beq $t1, 0, exit	#Exit loop if we encounter the null character. The strings are null terminated
		
		sltiu $t2, $t1, 97	#check if the letter is a lower case alphabet
		nor $t2, $t2, $zero	#since there is no sgtiu, we compare if $t1<97 and invert the condition
					# NOTE: a nor zero = a inverse
		sltiu $t3, $t1, 123
		and $t2, $t2, $t3	# t2 = (t1>=97 and t1 <123)
		beq $t2, 0, skip	#if t2==0, then t1 does not contain a lowercase alphabet. Skip conversion to uppercase
		
		sub $t1, $t1, 32	#else convert to uppercase
		
skip:		sb $t1, string($t0)	#store byte to the original location
		addi $t0, $t0, 1	#update the index
		j loop
	
		

exit:		li $v0, 4		#Display the string
		la $a0, string
		syscall	
		
		li $v0, 10		#Sys_exit
		syscall
