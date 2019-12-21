.data
	nums: .word 22
	#elems: .word 16, 12, 2, 5, 18, 23, 56, 91, 18, 18
	elems: .word 1, 9, 3, 4, 5, 3, 3, 3
	length: .word 8
	space: .asciiz "   "
	input: .asciiz "\nInput an integer number: "
	index: .asciiz "\nIndex: "
	nothing: .asciiz "\nNo Result!!!"
.text
	li $t1, 0		# i = 0
	la $t3, elems		# load base of array
	lw $t2, length		# length
	addi $t8, $t2, -2
	addi $t2, $t2, -1	# length - 1
	
	
	move $s6, $t1
ascend_loop_i:
	bgt $s6, $t8, exit_loop_i	# exit if i >= size - 2
	addi $s7, $s6, 1		# j = i + 1
	ascend_loop_j:
		bgt $s7, $t2, exit_loop_j
		mul $t4, $s6, 4		# i = 0
		add $t4, $t3, $t4
		lw $s3, 0($t4)		# Arr[i]
		mul $t5, $s7, 4		
		add $t5, $t3, $t5
		lw $s4, 0($t5)		# Arr[j]

		# SWAP
		blt $s3, $s4, endif	# if Arr[i] < Arr[j] -> exit
		sw $s4, 0($t4)		# Swap Arr[i] with Arr[j]
		sw $s3, 0($t5)
		endif:
		
		addi $s7, $s7, 1
		j ascend_loop_j
	exit_loop_j:
	addi $s6, $s6, 1
	j ascend_loop_i
exit_loop_i:

		# PRINT THE ARRAY
loop:
	bgt $t1, $t2, exit	# STOP WHEN i > length - 1
	mul $t5, $t1, 4
	add $t5, $t3, $t5
	lw $t5, 0($t5)		# load value of arr[i]
	
	li $v0, 1		# Print value of arr[i]
	move $a0, $t5
	syscall
	li $v0, 4		# Space between element
	la $a0, space
	syscall
	
	addi $t1, $t1, 1
	j loop
exit:	
	
		# INPUT
	li $v0, 4
	la $a0, input
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
	
		# BINARY
	li $a1, 0		# left = 0
	move $a2, $t2		# right = length - 1
	move $t6, $a1
	move $t7, $a2
lower:
	bgt $t6, $t7, savelow	

	add $t9, $t6, $t7	
	div $t9, $t9, 2		# Mid = (left + right) / 2

	mul $t5, $t9, 4
	add $t5, $t3, $t5
	lw $t5, 0($t5)		# Arr[MID]

	ble $s1, $t5, lowleft
	bgt $s1, $t5, lowright
lowleft:
	addi $t7, $t9, -1
	j lower
lowright:	
	addi $t6, $t9, 1
	j lower
next:
	move $t6, $a1
	move $t7, $a2
higher:
	bgt $t6, $t7, savehigh	

	add $t9, $t6, $t7	
	div $t9, $t9, 2		# Mid = (left + right) / 2

	mul $t5, $t9, 4
	add $t5, $t3, $t5
	lw $t5, 0($t5)		# Arr[MID]

	blt $s1, $t5, highleft
	bge $s1, $t5, highright
highleft:
	addi $t7, $t9, -1
	j higher
highright:	
	addi $t6, $t9, 1
	j higher
	
savelow:
	move $s6, $t6
	j next
savehigh:
	move $s7, $t7



	li $v0, 4		# Space between element
	la $a0, index
	syscall
display:
	bgt $s6, $s7, end	# STOP WHEN lower > upper
	
	li $v0, 1		# Print value of arr[i]
	move $a0, $s6
	syscall
	li $v0, 4		# Space between element
	la $a0, space
	syscall
	
	addi $s6, $s6, 1
	j display
end:
