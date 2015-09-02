.data

	HINT:		.asciiz		"Here's a hint! You are now out of hints.\n"
	THE_WORD:	.asciiz		"The word is "
	OUT_OF_HINTS:	.asciiz		"I'm sorry, you are out of hints!\n"
	word:		.asciiz		"hello"
	ast:		.asciiz		"_*___"
	space:		.asciiz		" "
.text

	la $s4, 1
	li $a0, 5
	la $a1, word
	la $a2, ast
	jal HINT_GENERATOR
	move $a1, $v0
	
	jal PRINTSPACE
	
	li $v0, 10
	syscall
	
	HINT_GENERATOR:
	#PROLOGUE
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	#MAIN BODY
		HINT_LOOP:
		beq $s4, 1, OUT_OF_HINT	#check if uer is out of hints
		move $s0, $a0			
		jal RANDOMNUM			#generate random number between 0 and size
		move $t0, $v0			#move random number into $t0
		
		# add $t0 to both pointers
		add $a1, $a1, $t0	
		add $a2, $a2, $t0
		#load both bytes of strings
		lb $t1, 0($a1)
		lb $t2, 0($a2)
		#if the pointer is a * try again
		beq $t2, '*', HINT_CONT
		sb $t1, 0($a2)			# if not a * insert character as hint
		j HINT_PRINT
		HINT_CONT:
		#put pointers back to zero if *
		sub $a1, $a1, $t0
		sub $a2, $a2, $t0
		j HINT_LOOP
		
		OUT_OF_HINT:
		li $v0, 4
		la $a0, OUT_OF_HINTS
		syscall
		
		li $v0, 4
		la $a0, THE_WORD
		syscall
		j HINT_END
		
	HINT_PRINT:
	li $v0, 4
	la $a0, HINT
	syscall
	
	li $v0, 4
	la $a0, THE_WORD
	syscall
	
	#add to the Hint counter here
	#
	#
	
	HINT_END:
	#EPILOGUE
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	
	move $v0, $a2
	#RETURN
	jr $ra
	
	
	RANDOMNUM:
		#PROLOGUE
		subi $sp, $sp, 12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		
		#MAIN BODY
		li $v0, 30
		syscall
		#a0 has sort of ranom number based on system time
	
		#a1 maximum value
		move $a1, $s0
	
		#random number generation
		li $v0, 42
		syscall
		#a0 has your random number
		
		#return random number
		move $v0, $a0
		
		#EPILOGUE
		lw $a1, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
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
			COUNT:				#counts number of characters
				lbu $t3, 0($a1)
				beqz $t3, prints
				addi $a1, $a1, 1
				addi $t1, $t1, 1		#number of characters in $t1
				j COUNT
				
				prints:
				lw $a1, 8($sp)			#sets $a1 back to original
				li $t2, 0			# start counter
			PLOOP:
				beq $t2, $t1, end		#counter check
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
				
		end:
		#epilogue
		lw $a2, 12($sp)
		lw $a1, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		#return
		jr $ra
	
	
	
	
	
	