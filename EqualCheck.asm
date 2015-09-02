.data
	word1:		.asciiz		"hello"
	word2:		.asciiz		"hello"
	word3:		.asciiz		"seven"
	word4:		.asciiz		"hellos"
	word5:		.asciiz		"hel"
.text

	la $a0, word1
	la $a1, word5
	jal EQUAL_CHECK
	
	move $a0, $v0
	
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	EQUAL_CHECK:	
	#prologue
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	#main body
	
		CHECK_LOOP:
			
			lb $t0, 0($a0)
			lb $t1, 0($a1)
			
			bne $t0, $zero, CHECK
			bne $t1, $zero, NOT_EQUAL
			beqz $t1, END2
			
			CHECK:
			bne $t0, $t1, NOT_EQUAL
			addi $a0, $a0, 1
			addi $a1, $a1, 1
			j CHECK_LOOP
			
			NOT_EQUAL:
			li $v0, 0
			j END3
			
			END2:
			li $v0, 1
			
	END3:
	#epilogue
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	#return
	jr $ra