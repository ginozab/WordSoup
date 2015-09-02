.data
	ast:		.asciiz		"_*_*_"
	word:		.asciiz		"hello"
	space:		.asciiz		" "
	newline:	.asciiz		".\n"
	WELCOME:	.asciiz		"Welcome to WordSoup!\n"
	FIRST_PROMPT:	.asciiz		"\nI am thinking of a word. The word is "
	FIRST_PROMPT1:	.asciiz		". Round score is "
	FIRST_PROMPT2:	.asciiz		"Guess a letter?\n"
	WRONG_GUESS:	.asciiz		"\nNo! The word is "
	LOST_ROUND:	.asciiz		"You lost the round!" 
	FINAL_STATE:	.asciiz		" The final state of you word was:\n"
	CORRECT_WORD:	.asciiz		"\nCorrect word was:\n"
	YOUR_ROUNDSCORE:.asciiz		"\nYour round score is "
	GAME_TALLY:	.asciiz		". Game tally is "
	PLAY_AGAIN:	.asciiz		"\nDo you want to play again? (y/n) "
	CORRECT:	.asciiz		"\nCorrect! The word is "
	CORRECT_ROUND:	.asciiz		"\nCorrect!"
	FORFEIT:	.asciiz		"You forfeited the round!\n"
	FINAL_STATE1:	.asciiz		"The final state of you word was:\n"
	HINT:		.asciiz		"Here's a hint! You are now out of hints.\n"
	THE_WORD:	.asciiz		"The word is "
	OUT_OF_HINTS:	.asciiz		"I'm sorry, you are out of hints!\n"
	WHAT_GUESS:	.asciiz		"What is your guess?\n"
	CORRECT_GUESS:	.asciiz		"You guessed the word correctly!\n"
	CORRECT_GUESS1:	.asciiz		", doubled to "
	TERRIBLE_GUESS:	.asciiz		"That guess was terrible!\n"
	TALLY_PENALTY:	.asciiz		"Your Game Tally is being penalized by "
.text
	LOOP:
	la $s1, word
	la $s2, ast
	jal FORFEIT_PROC
	
	li $v0, 12
	syscall
	
	beq $v0, 'y', LOOP
	
	li $v0, 10
	syscall
	
	
	#------------------------Procedure to Forfeit---------------------------------#
	FORFEIT_PROC:
		#PROLOGUE
		subi $sp, $sp, 12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $s2, 8($sp)
		
		#MAIN BODY
			li $v0, 4
			la $a0, FORFEIT
			syscall
			
			li $v0, 4
			la $a0, FINAL_STATE1
			syscall
			
			jal PRINTSPACE
			
			li $v0, 4
			la $a0, CORRECT_WORD
			syscall
			
			move $a0, $s1
			li $v0, 4
			syscall
			
			
			li $v0, 4
			la $a0, YOUR_ROUNDSCORE
			syscall
			
			#print round SCore
			#
			
			li $v0, 4
			la $a0, GAME_TALLY
			syscall
			
			#print game tally
			#
			
			li $v0, 4
			la $a0, PLAY_AGAIN
			syscall
			
			
		#EPILOGUE
		lw $s2, 8($sp)
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
		sw $s2, 8($sp)
		sw $a2, 12($sp)
		
		#main body
			la $a2, space
			li $t1, 0
			COUNTER:				#counts number of characters
				lbu $t3, 0($s2)
				beqz $t3, prints
				addi $s2, $s2, 1
				addi $t1, $t1, 1		#number of characters in $t1
				j COUNTER
				
				prints:
				lw $s2, 8($sp)			#sets $a1 back to original
				li $t2, 0			# start counter
			PLOOP:
				beq $t2, $t1, end1		#counter check
				lb $t4, 0($s2)			#load character in $a1
				
				#print out charcater
				move $a0, $t4			
				li $v0, 11
				syscall
				
				#print space
				move $a0, $a2
				li $v0, 4
				syscall
				
				#add to counters
				addi $s2, $s2, 1
				addi $t2, $t2, 1
				
				j PLOOP
				
		end1:
		#epilogue
		lw $a2, 12($sp)
		lw $s2, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		#return
		jr $ra