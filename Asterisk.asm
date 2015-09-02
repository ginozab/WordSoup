.data
	wordbank:	.asciiz  "computer" "game" "science" "word" "hangman" "Wordsoup" "quadrant" "gigantic"
	
	
.text
	la $s7, '*'
	la $s6, '_'
	
	#generate random number
	la $s0, 8
	jal RANDOMNUM
	move $a0, $v0
	
	#get word
	jal WORDFIND
	move $a0, $v0
	
	li $v0, 4
	syscall
	

	jal ASTERISK
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	#end program
	li $v0, 10
	syscall
	
	WORDFIND:
	#prologue
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	
	# main body
	
	la $s0, wordbank
	#seed random generator
	
	
	#li $v0, 1
	#syscall
	
	#if random number is 0 just print the address of wordbank
	beq $a0, $zero, first
	# if not continue down to rest of code
	bne $a0, $zero, find
	
	#print out the address of wordbank
	first:
	move $v0, $s0
	j end
	
	#if random number is not 0 find the word
	find:
	
	#counter for the number of 0's found
	li $t0, 0
	
	LOOP:
		#load pointer of wordbank
		lb $s1, 0($s0)
		# if the value of pointer is not 0 continue on to next pointer
		bne $s1, $zero, point
		
		# if it is equal to 0 add to zero counter
		addi $t0, $t0, 1
		# if $t0 to random number go down to print word
		beq $t0, $a0, pointer
		
		point:
		#move pointer of wordbank
		addi $s0, $s0, 1
		
		#jump back to loop
		j LOOP
		
		pointer:
		#go to the beginning of the word by adding to the pointer
		addi $s0, $s0, 1
		# return address of word
		move $v0, $s0
		
	end:	
	#epilogue
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	#return
	jr $ra
	
	
	RANDOMNUM:
		#PROLOGUE
		subi $sp, $sp, 8
		sw $ra, 0($sp)
		
		
		
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
		
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		#RETURN
		jr $ra
		
	ASTERISK:
	#PROLOGUE
	subi $sp, $sp, 8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	
	#MAIN BODY
		move $t8, $a0
		li $t1, 0
		COUNT:
		lb $t3, 0($a0)
		beqz $t3, replace
		addi $a0, $a0, 1
		addi $t1, $t1, 1
		j COUNT
		replace:
		la $s0, 3
		jal RANDOMNUM
		move $t2, $v0
		addi $t2, $t2, 1
		li $t0, 0
		LOOP1:
			beq $t0, $t2, dashes
			move $s0, $t1
			jal RANDOMNUM
			move $t4, $v0
			addi $t4, $t4, 1
			add $t8, $t8, $t4
			sb $s7, 0($t8)
			addi $t0, $t0, 1
			sub $t8, $t8, $t4
			j LOOP1
		dashes:
		LOOP2:
		beqz $t8, exit
		lb $t5, 0($t8)
		beq $t5, $s7, skip
		sb $s6, 0($t8)
		
		skip:
		addi $t8, $t8, 1
		j LOOP2
		
		exit:
		move $v0, $t8
			
	#EPILOGUE
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	#RETURN
	jr $ra	
