.data
	wordbank:	.asciiz		"computer" "game" "science" "word" "hangman" "Wordsoup" "quadrant" "gigantic"
	
	newline:	.asciiz		".\n"
	WELCOME:	.asciiz		"Welcome to WordSoup!\n\n"
	FIRST_PROMPT:	.asciiz		"I am thinking of a word. The word is "
	FIRST_PROMPT1:	.asciiz		". Round score is "
	FIRST_PROMPT2:	.asciiz		"Guess a letter?\n"
	WRONG_GUESS:	.asciiz		"No! The word is "
	LOST_ROUND:	.asciiz		"You lost the round!" 
	FINAL_STATE:	.asciiz		" The final state of you word was:\n"
	CORRECT_WORD:	.asciiz		"Correct word was:\n"
	YOUR_ROUNDSCORE:.asciiz		"Your round score is "
	GAME_TALLY:	.asciiz		". Game tally is "
	PLAY_AGAIN:	.asciiz		"Do you want to play again? (y/n) "
	CORRECT:	.asciiz		"Correct! The word is "
	CORRECT_ROUND:	.asciiz		"Correct!"
	FORFEIT:	.asciiz		"You forfeited the round!\n"
	HINT:		.asciiz		"Here's a hint! You are now out of hints.\n"
	THE_WORD:	.asciiz		"The word is "
	OUT_OF_HINTS:	.asciiz		"I'm sorry, you are out of hints!\n"
	WHAT_GUESS:	.asciiz		"What is your guess?\n"
	CORRECT_GUESS:	.asciiz		"You guessed the word correctly!\n"
	CORRECT_GUESS1:	.asciiz		", doubled to "
	TERRIBLE_GUESS:	.asciiz		"That guess was terrible!\n"
	TALLY_PENALTY:	.asciiz		"Your Game Tally is being penalized by "
	
	
.text

	
	#generate random number
	la $s0, 8
	jal RANDOMNUM
	move $a0, $v0
	
	#get word
	jal WORDFIND
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
	sw $a1, 8($sp)
	
	
	# main body
	
	la $a1, wordbank
	#seed random generator
	
	
	#li $v0, 1
	#syscall
	
	#if random number is 0 just print the address of wordbank
	beq $a0, $zero, first
	# if not continue down to rest of code
	bne $a0, $zero, find
	
	#print out the address of wordbank
	first:
	move $v0, $a1
	j end
	
	#if random number is not 0 find the word
	find:
	
	#counter for the number of 0's found
	li $t0, 0
	
	LOOP:
		#load pointer of wordbank
		lb $t1, 0($a1)
		# if the value of pointer is not 0 continue on to next pointer
		bne $t1, $zero, point
		
		# if it is equal to 0 add to zero counter
		addi $t0, $t0, 1
		# if $t0 to random number go down to print word
		beq $t0, $a0, pointer
		
		point:
		#move pointer of wordbank
		addi $a1, $a1, 1
		
		#jump back to loop
		j LOOP
		
		pointer:
		#go to the beginning of the word by adding to the pointer
		addi $a1, $a1, 1
		# return address of word
		move $v0, $a1
		
	end:	
	#epilogue
	
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	#return
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
		
	
		
	
		
		