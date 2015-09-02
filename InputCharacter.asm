.data
	word:		.asciiz		"hello"
	ast:		.asciiz		"_*___"
	newline:	.asciiz		"\n"
	WRONG_GUESS:	.asciiz		"\nNo! The word is "
	CORRECT:	.asciiz		"\nCorrect! The word is "
	space:		.asciiz		" "
.text

	li $v0, 12
	syscall
	
	move $a1, $v0
	la $a0, word
	la $a2, ast
	
	jal INPUT
	
	move $a1, $v0
	jal PRINTSPACE
	
	li $v0, 10
	syscall
	
	INPUT:
	#PROLOGUE
	subi $sp, $sp, 8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	#sw $a1, 8($sp)
	sw $a2, 4($sp)
	
	#MAIN BODY
		li $t3, 0
		LOOP3:
			lbu $t1, 0($a0)			#load character from word into $t1
			beq $t1, $zero, REPLACEEXIT	# checks if character is valid
			
			beq $t1, $a1, pointer1		#compares character to user input
			
			addi $a0, $a0, 1		#moves pointer
			addi $a2, $a2, 1		#moves pointer
			j LOOP3			
			pointer1:
			lbu $t2, 0($a2)			#load byte of asterisk string
			beq $t2, '*', skip		#if character is * 
			sb $a1, 0($a2)			#store user input into $a2
			addi $t3, $t3, 1
			skip:
			addi $t3, $t3, 1
			addi $a2, $a2, 1		#add to pointer for $a2, $a0
			addi $a0, $a0, 1
			j LOOP3
			
			REPLACEEXIT:
			
			bge $t3, 1, CORRECT_CHARACTER
				
				li $v0, 4
				la $a0, WRONG_GUESS
				syscall
				
				#decrement round score here
				#
				#
				
				j INPUT_EXIT
				
			CORRECT_CHARACTER:
				
				li $v0, 4
				la $a0, CORRECT
				syscall
							
	
	INPUT_EXIT:
	
	
	#EPILOGUE
	lw $a2, 4($sp)
	#lw $a1, 8($sp)
	#lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	#return string
	move $v0, $a2
	#RETURN
	jr $ra


	PRINTSPACE:
		#prologue
		subi $sp, $sp, 16
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		
		#main body
			la $a2, space
			li $t1, 0
			COUNTER:				#counts number of characters
				lbu $t3, 0($a1)
				beqz $t3, prints
				addi $a1, $a1, 1
				addi $t1, $t1, 1		#number of characters in $t1
				j COUNTER
				
				prints:
				lw $a1, 8($sp)			#sets $a1 back to original
				li $t2, 0			# start counter
			PLOOP:
				beq $t2, $t1, end1		#counter check
				lb $t4, 0($a1)			#load character in $a1
				
				#print out charcater
				move $a0, $t4			
				li $v0, 11
				syscall
				
				#print space
				move $a0, $a2
				li $v0, 4
				syscall
				
				#add to counters
				addi $a1, $a1, 1
				addi $t2, $t2, 1
				
				j PLOOP
				
		end1:
		#epilogue
		lw $a2, 12($sp)
		lw $a1, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		#return
		jr $ra
	
