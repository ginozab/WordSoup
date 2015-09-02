.data
	word1:		.asciiz		"hello"
	word2:		.asciiz		"hello"
	word3:		.asciiz		"seven"
	word4:		.asciiz		"hellos"
	word5:		.asciiz		"hel"
	buffer:		.space		20
.text

	jal GUESS_ANSWER
	
	li $v0, 10
	syscall
	
	GUESS_ANSWER:
	#PROLOGUE
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	#MAIN BODY
	
         la $a0, buffer 		#load byte space into address
         la $a1, buffer 		# allot the byte space for string
         li $v0,8 			#take in input
         move $t0,$a0 			#save string to t0
         syscall
         
         la $a0, buffer			#reload byte space to primary address
         move $a2, $a0			#move user input into $a1
         #la $a2, word2
         la $a1, word1			#load original word
        
         jal EQUAL_CHECK
         
         beq $v0, 1, EQUAL_WORDS	# if EQUAL_CHECK returns 1 EQUAL if 0 NOT EQUAL 
         
         #if the words are not equal
         move $a0, $v0
         li $v0, 1
         syscall
         j END_CHECK
         
         #if the words are equal
         EQUAL_WORDS:
         move $a0, $v0
         li $v0, 1
         syscall
         
         li $v0, 4
         la $a0, word1
         syscall
         
	END_CHECK:
	#EPILOGUE
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	#RETURN
	jr $ra
	
	
	
	
	
	
	EQUAL_CHECK:	
	#prologue
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	#main body
	
		CHECK_LOOP:
			#load characters
			lb $t0, 0($a1)
			lb $t1, 0($a2)
			
			# if $t0 is not equal to zero move to check characters
			# if is equal to zero continue
			bne $t0, $zero, CHECK
			# and if $t1 is not equal to zero $t0, $t1 not equal
			bne $t1, $zero, NOT_EQUAL
			#if $t1 is = zero then they are equal j to end
			beqz $t1, END2
			
			CHECK:
			bne $t0, $t1, NOT_EQUAL		#if characters are not equal return 0
			
			#add to counters if equal
			addi $a1, $a1, 1			
			addi $a2, $a2, 1
			j CHECK_LOOP
			
			NOT_EQUAL:
			li $v0, 0			#not equal return 0
			j END3
			
			END2:
			li $v0, 1			#equal return 1
			
	END3:
	#epilogue
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	#return
	jr $ra