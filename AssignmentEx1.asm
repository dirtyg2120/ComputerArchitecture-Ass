.data
	#elems: .word 1, 8, 3, 9, 4, 5, 7
	elems: .word 1, 9, 3, 4, 5, 6, 3, 3
	length: .word 8
	space: .asciiz "   "
	
.text
.globl main
main:
	li $t1, 0		# i = 0
	la $t3, elems		# load base of array
	addi $a0, $t3, 0
	lw $t2, length		# length
	addi $t2, $t2, -1	# length - 1
	
	#	Quicksort
	move $a1, $t1
	move $a2, $t2
	jal quicksort
	#	Display
	j display
	#	Exit
	#li $v0, 10
	#syscall
#---------------------------------------------------------
partition:
	addu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)	# Array
	sw $a1, 8($sp)	# LOW
	sw $a2, 12($sp)	# HIGH

	move $s6, $a1		# Left
	addi $s7, $a2, -1	# Right
	
	mul $t5, $a2, 4		
	add $t5, $t3, $t5
	lw $t8, 0($t5)		# Pivot = arr[length - 1]
while_true:
whileLeft:
	mul $t4, $s6, 4		
	add $t4, $t3, $t4
	lw $t4, 0($t4)		# Arr[Left]
	
	slt $s1, $t4, $t8
	sgt $s2, $s6, $s7
	add $s3, $s1, $s2
	
	bge $s3, 1, whileRight	# if(Arr[left] < pivot) -> end
	addi $s6, $s6, 1	# Left++
	j whileLeft
	
whileRight:
	mul $t5, $s7, 4		
	add $t5, $t3, $t5
	lw $t5, 0($t5)		# Arr[Right]

	sgt $s1, $t5, $t8
	sgt $s2, $s6, $s7
	add $s3, $s1, $s2
	
	bge $s3, 1, endRight	# if(Arr[Right] > pivot) -> end
	addi $s7, $s7, -1	# Right--
	j whileRight
	
endRight:
	bge $s6, $s7, end_while
	# SWAP
	# sub $t4, $t4, $t4
	# sub $t5, $t5, $t5
	
	mul $t4, $s6, 4		
	add $t4, $a0, $t4
	lw $s3, 0($t4)		# temp = Arr[Left]
	
	mul $t5, $s7, 4
	add $t5, $a0, $t5
	lw $s4, 0($t5)
	
	sw $s4, 0($t4)		# Arr[Left] = Arr[Right]
	sw $s3, 0($t5)		# Arr[Right] = temp
	
	addi $s6, $s6, 1	# Left++
	addi $s7, $s7, -1	# Right--
	j while_true
end_while:
	#SWAP
	mul $t4, $s6, 4		
	add $t4, $a0, $t4
	lw $s3, 0($t4)		# temp = Arr[Left]
	
	mul $t5, $a2, 4		
	add $t5, $a0, $t5
	lw $s4, 0($t5)		
	
	sw $s4, 0($t4)		# Arr[Left] = Arr[High]
	sw $s3, 0($t5)		# Arr[High] = temp
done_partition:
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)	
	lw $a2, 12($sp)	
	addu $sp, $sp, 16
	move $v0, $s6
	jr $ra
#---------------------------------------------------------
quicksort:
	addu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	bge $a1, $a2, end_quicksort
	jal partition
	move $s0, $v0
	
	lw $a1, 8($sp)			
	addi $a2, $s0, -1
	jal quicksort
	
	addi $a1, $s0, 1		
	lw $a2, 12($sp)			
	jal quicksort			
end_quicksort:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addu $sp, $sp, 16
	
	jr $ra
#---------------------------------------------------------
display:
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
	j display
exit:
	li $v0, 10
	syscall
