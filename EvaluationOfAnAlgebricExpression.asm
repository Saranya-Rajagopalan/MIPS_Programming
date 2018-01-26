###################################################################
# OBJECTIVE:
#	to find u2 + 5uv - 3v2 + 7
#
# To have two procedures to perform square and multiplication 
# respectively and return the calculated value
###################################################################

###################################################################
#	Data
###################################################################
.data
enteru: .asciiz "Enter the value of u"
enterv: .asciiz "Enter the value of v"

##################################################################
# 	Text
##################################################################
.text

	.globl main
	
main:
	li $v0, 4		#Prompt the user to enter u
	la $a0, enteru
	syscall
	
	li $v0, 5		#save u
	syscall
	
	move $t0, $v0
	
	li $v0, 4		#Prompt the user to enter v
	la $a0, enterv
	syscall
	
	li $v0,  5		#save v
	syscall
	
	move $t1, $v0
	
	move $a0, $v0		#load the arguments u in $a0
	jal sqr			#square u
	move $s0, $v0		#save the result in $s0
	
	move $a0, $t0		#load the argument v in $a0
	jal sqr			#square v
	move $s1, $v0		#save the result in $s1
	li $s3, -3		#save constant -3 in $s3
	mul $s1, $s3, $s1	# find -3v**2
	
	move $a1, $t0		#load u in $a1 
	jal multiply		#note that v is already in $a0
	move $s2, $v0		#save uv in $s2
	li $s3, 5		#save constant 5 in $s3
	mul $s2, $s2, $s3	#save 5uv in $s2
	
	add $s0, $s0, $s1	# u**2 -3v**2 is saved in $s0
	add $s0, $s0, $s2	# u**2 -3v**2 + 5uv saved in  $s0
	addi $s0, $s0, 7	# add constant 7 to the expression
	
	li $v0, 1		#display the integer
	move $a0, $s0		# argument is the integer to be displayed
	syscall
	
	j exit
	
	
	
		
	
sqr:	mul $v0, $a0, $a0
	jr $ra
	
multiply: mul $v0, $a0, $a1
	jr $ra
	
exit:	li $v0, 10
	syscall
	
	
