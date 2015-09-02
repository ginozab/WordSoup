.data
	wordbank:	.asciiz		"computer" "hangman" "world" "processor" "database" 
					"wordsoup" "quadrant" "gigantic" "firewall" "internet" 
					"binary" "android" "recursion" "amdahl" "benchmark" 
					"algorithm" "gigahertz" "execution" "register" "procedure"
					"parameter" "pointer" "stack" "float" "immediate"
					"branch" "opcode" "integer" "argument" "method"
	
	space:		.asciiz		" "
	newline:	.asciiz		".\n"
	THANK_YOU:	.asciiz		"\nThank You for playing!!"
	WELCOME:	.asciiz		"\n\nWelcome to WordSoup!\n"
	FIRST_PROMPT:	.asciiz		"\nI am thinking of a word. The word is "
	FIRST_PROMPT1:	.asciiz		". Round score is "
	FIRST_PROMPT2:	.asciiz		"\nGuess a letter?\n"
	WRONG_GUESS:	.asciiz		"\nNo! "
	LOST_ROUND:	.asciiz		"\nYou lost the round!" 
	FINAL_STATE:	.asciiz		" The final state of you word was:\n"
	CORRECT_WORD:	.asciiz		"\nCorrect word was:\n"
	YOUR_ROUNDSCORE:.asciiz		"\nYour round score is "
	YOUR_ROUNDSCORE_ZERO:.asciiz		"\nYour round score is 0"
	GAME_TALLY:	.asciiz		". Game tally is "
	PLAY_AGAIN:	.asciiz		".\nDo you want to play again? (y/n) "
	CORRECT:	.asciiz		"\nCorrect! The word is "
	CORRECT_ROUND:	.asciiz		"\nCorrect! "
	FORFEIT:	.asciiz		"\nYou forfeited the round!\n"
	FINAL_STATE1:	.asciiz		" The final state of you word was:\n"
	HINT:		.asciiz		"\nHere's a hint! You are now out of hints.\n"
	THE_WORD:	.asciiz		"The word is "
	OUT_OF_HINTS:	.asciiz		"\nI'm sorry, you are out of hints!\n"
	WHAT_GUESS:	.asciiz		"\nWhat is your guess?\n"
	CORRECT_GUESS:	.asciiz		"\nYou guessed the word correctly!\n"
	CORRECT_GUESS1:	.asciiz		", doubled to "
	TERRIBLE_GUESS:	.asciiz		"That guess was terrible!\n"
	TALLY_PENALTY:	.asciiz		"\nYour Game Tally is being penalized by -"
	user_guesses:	.space		10
	user_stars_spaces: .space	10
	buffer:		.space		20
	
	
.text

#------------------------Generate Word/ Stars and Spaces--------------------------------#	
	#counter for game tally
	li $s4, 0
	
	MAIN_LOOP:
	la $s2, user_stars_spaces
	la $s3, user_guesses
	
	jal RESTORE
	
	la $s2, user_stars_spaces
	la $s3, user_guesses
	
	
	#generate random number
	la $s0, 30
	jal RANDOMNUM
	move $a0, $v0
	
	#get word
	jal WORDFIND
	
	move $s1, $v0
	
	#make stars and Spaces string
	jal ASTERISK
	
#------------------------First User Prompt----------------------------------#
	#counter for round score
	jal LENGTH_COUNTER
	move $s5, $v0
	
	li $v0, 4
	la $a0, WELCOME
	syscall
	
	#li $v0, 4
	#move $a0, $s1
	#syscall
	
	li $v0, 4
	la $a0, FIRST_PROMPT
	syscall
	
	la $s2, user_stars_spaces
	jal PRINTSPACE
	
	li $v0, 4
	la $a0, FIRST_PROMPT1
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, FIRST_PROMPT2
	syscall
	
#---------------------------User input-----------------------------------#
	#counter for hint tally
	li $s6, 0
	GAME_LOOP:
	
	
	#TAKES IN USER INPUT
	li $v0, 12
	syscall
	
	#CHECKS DIFFERENT USER INPUTS
	beq $v0, '.', Forfeit
	beq $v0, '!', Guess
	beq $v0, '?', Hint

#--------------------UI = letter-----------------------------------------#	
	move $a1, $v0
	
	la $s2, user_stars_spaces
	la $s3, user_guesses
	
	jal INPUT		#TAKES IN USER INPUT
	
	#CHECK TO SEE IF ROUND SCORE = 0
	beq $s5, 0, LOST_THIS_ROUND
	beq $v0, 1, CORRECT_CONTINUE
	
	li $v0, 4
	la $a0, WRONG_GUESS
	syscall
	
	CORRECT_CONTINUE:
	
	jal EQUAL_CHECK_END		#CHECKS IF USER HAS GUESSED ALL LETTERS
	
	beq $v0, 1, ALL_CORRECT		#CHECKS IF EQUAL_CHECK_END RETURNS 1
#------------------IF USER STILL NEEDS TO GUESS LETTERS------------------#	
	li $v0, 4
	la $a0, THE_WORD
	syscall
	
	la $s2, user_stars_spaces
	jal PRINTSPACE			#PRINT SPACES INBETWEEN
	
	li $v0, 4
	la $a0, FIRST_PROMPT1
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, FIRST_PROMPT2
	syscall
	
	j GAME_LOOP
#---------------------IF USER GETS ALL LETTERS------------------#	
	ALL_CORRECT:
	
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
	
	#ROUND SCORE PRINT
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, GAME_TALLY
	syscall
	
	add $s4, $s4, $s5
	
	#print game Tally here
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, PLAY_AGAIN
	syscall
	
	#TAKES IN USER ANSWER
	li $v0, 12
	syscall
	
	beq $v0, 'y', MAIN_LOOP		#CHECKS IF USER WANTS TO PLAY AGIAN
	
	j END_WORDSOUP
#-----------------------------------------------------------------------#	


#------------------------UI Guess answer--------------------------------#
	Guess:
	jal GUESS_ANSWER
	
	li $v0, 12		#TAKES IN USER ANSWER
	syscall
	
	beq $v0, 'y', MAIN_LOOP		#CHECKS IF USER WANTS TO PLAY AGAIN
	
	j END_WORDSOUP
	
#-----------------------------------------------------------------------#

#-----------------------------UI HINT-----------------------------------#

	Hint:
	jal HINT_GENERATOR
	
	jal EQUAL_CHECK_END		#CHECKS IF USER HAS GUESSED ALL LETTERS
	
	beq $v0, 1, ALL_CORRECT		#CHECKS IF EQUAL_CHECK_END RETURNS 1
	
	#la $s2, user_stars_spaces
	#la $s3, user_guesses
	
	jal PRINTSPACE
	
	li $v0, 4
	la $a0, FIRST_PROMPT1
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, FIRST_PROMPT2
	syscall
	
	j GAME_LOOP

#-----------------------------------------------------------------------#
	
#--------------------------UI Forfeit-----------------------------------#
	Forfeit:
	jal FORFEIT_PROC
	
	li $v0, 12
	syscall
	
	beq $v0, 'y', MAIN_LOOP
	
	j END_WORDSOUP
	
#-----------------------------------------------------------------------#
	
#----------------------IF USER RUNS OUT OF GUESSES----------------------#	
	LOST_THIS_ROUND:
		li $v0, 4
		la $a0, LOST_ROUND
		syscall
		
		li $v0, 4
		la $a0, FINAL_STATE
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
		
		#print out round score
		move $a0, $s5
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, GAME_TALLY
		syscall
		
		#print out game tally
		li $v0, 1
		move $a0, $s4
		syscall
		
		li $v0, 4
		la $a0, PLAY_AGAIN
		syscall
		
		li $v0, 12
		syscall
		
		beq $v0, 'y', MAIN_LOOP
		
#-----------------------------End Game----------------------------------#
	END_WORDSOUP:
	li $v0, 4
	la $a0, THANK_YOU
	syscall
	
	#end program
	li $v0, 10
	syscall
#-------------------------------------------------------------------------#


#---------------------------Procedures--------------------------------------#
#
#
#
#----------------------------Input Procedure--------------------------------------#

	INPUT:
	#PROLOGUE
	subi $sp, $sp, 8
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	
	#MAIN BODY
		li $t3, 0
		LOOP3:
			lbu $t1, 0($s1)			#load character from word into $t1
			beq $t1, $zero, REPLACEEXIT	# checks if character is valid
			
			beq $t1, $a1, pointer1		#compares character to user input
			
			addi $s1, $s1, 1		#moves pointer
			addi $s2, $s2, 1		#moves pointer
			addi $s3, $s3, 1
			j LOOP3			
			
			pointer1:
			lbu $t2, 0($s2)			#load byte of asterisk string
			sb $a1, 0($s3)
			beq $t2, '*', skip		#if character is * 
			sb $a1, 0($s2)			#store user input into $a2
			sb $a1, 0($s3)
			addi $t3, $t3, 1
			
			skip:
			addi $t3, $t3, 1
			addi $s3, $s3, 1
			addi $s2, $s2, 1		#add to pointer for $a2, $a0
			addi $s1, $s1, 1
			j LOOP3
			
			REPLACEEXIT:
			
			bge $t3, 1, CORRECT_CHARACTER
				
				
				
				#decrement round score 
				subi $s5, $s5, 1
				
				j INPUT_EXIT
							
			CORRECT_CHARACTER:
				li $v0, 4
				la $a0, CORRECT_ROUND
				syscall
				
				#return 1 if correct character
				li $t9, 1
				move $v0, $t9
			
	INPUT_EXIT:
	
	
	#EPILOGUE
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	la $s2, user_stars_spaces
	la $s3, user_guesses
	
	
	#RETURN
	jr $ra

#----------------------------End Input Procedure---------------------------------#

#----------------------------Guess Answer Procedure--------------------------------#

	GUESS_ANSWER:
	#PROLOGUE
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a2, 12($sp)
	#MAIN BODY
	
	li $v0, 4
	la $a0, WHAT_GUESS
	syscall
	
         la $a0, buffer 		#load byte space into address
         la $a1, 20 			# allot the byte space for string
         li $v0,8 			#take in input
         move $t0,$a0 			#save string to t0
         syscall
         
         la $a0, buffer			#reload byte space to primary address
         move $a2, $a0			#move user input into $a1
        
         jal EQUAL_CHECK
         
         beq $v0, 1, EQUAL_WORDS	# if EQUAL_CHECK returns 1 EQUAL if 0 NOT EQUAL 
         
         #if the words are not equal
         
         li $v0, 4
         la $a0, TERRIBLE_GUESS
         syscall
         
         li $v0, 4
         la $a0, YOUR_ROUNDSCORE
         syscall
         
         #print round score
         li $v0, 1
	 move $a0, $s5
	 syscall
         
         li $v0, 4
         la $a0, CORRECT_GUESS1
         syscall
         
         #double the round score
         add $s5, $s5, $s5
         
         #print double round score
         li $v0, 1
	 move $a0, $s5
	 syscall
         
         li $v0, 4
         la $a0, TALLY_PENALTY
         syscall
         
         #print double round score
         li $v0, 1
	 move $a0, $s5
	 syscall
         
         li $v0, 4
         la $a0, GAME_TALLY
         syscall
         
         #subtract double from game tally
         sub $s4, $s4, $s5
         
         #print out game tally
         li $v0, 1
	 move $a0, $s4
	 syscall
         
         li $v0, 4
         la $a0, PLAY_AGAIN
         syscall
         
         j END_CHECK
         
         #if the words are equal
         EQUAL_WORDS:
         
         li $v0, 4
         la $a0, CORRECT_GUESS
         syscall
         
         li $v0, 4
         la $a0, YOUR_ROUNDSCORE
         syscall
         
         li $v0, 1
	 move $a0, $s5
	 syscall
         
         li $v0, 4
         la $a0, CORRECT_GUESS1
         syscall
         
         #double the round score
         add $s5, $s5, $s5
         
         #print double round score
         li $v0, 1
	 move $a0, $s5
	 syscall
         
         li $v0, 4
         la $a0, GAME_TALLY
         syscall
         
         add $s4, $s4, $s5
         #print out game tally
         li $v0, 1
	 move $a0, $s4
	 syscall
         
         li $v0, 4
         la $a0, PLAY_AGAIN
         syscall
         
         
	END_CHECK:
	#EPILOGUE
	lw $a2, 12($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#RETURN
	jr $ra
	
#------------------------------End Guess Answer Procedure-------------------------#
	
	
#------------------------------String Equal Check Procedure-----------------------#
	
	EQUAL_CHECK:	
	#prologue
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $a2, 8($sp)
	
	#main body
	
		CHECK_LOOP:
			#load characters
			lb $t0, 0($s1)
			lb $t1, 0($a2)
			
			# if $t0 is not equal to zero move to check characters
			# if is equal to zero continue
			bne $t0, $zero, CHECK
			# and if $t1 is not equal to zero $t0, $t1 not equal
			bne $t1, 10, NOT_EQUAL
			#if $t1 is = zero then they are equal j to end
			j END2
			
			CHECK:
			bne $t0, $t1, NOT_EQUAL		#if characters are not equal return 0
			
			#add to counters if equal
			addi $s1, $s1, 1			
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
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	#return
	jr $ra

#-----------------------------End Equal check procedure--------------------------#

EQUAL_CHECK_END:	
	#prologue
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s3, 8($sp)
	
	#main body
	
		CHECK_LOOP1:
			#load characters
			lb $t0, 0($s1)
			lb $t1, 0($s3)
			
			# if $t0 is not equal to zero move to check characters
			# if is equal to zero continue
			bne $t0, $zero, CHECK1
			# and if $t1 is not equal to zero $t0, $t1 not equal
			bne $t1, ' ', NOT_EQUAL1
			#if $t1 is = zero then they are equal j to end
			j END21
			
			CHECK1:
			bne $t0, $t1, NOT_EQUAL1		#if characters are not equal return 0
			
			#add to counters if equal
			addi $s1, $s1, 1			
			addi $s3, $s3, 1
			j CHECK_LOOP1
			
			NOT_EQUAL1:
			li $v0, 0			#not equal return 0
			j END3
			
			END21:
			li $v0, 1			#equal return 1
			
	END31:
	#epilogue
	lw $s3, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	#return
	jr $ra

#-------------------------End check if equal procedure---------------------------#

#-----------------------------Hint Generator procedure----------------------------#

	HINT_GENERATOR:
	#PROLOGUE
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	#MAIN BODY
		beq $s6, 1, OUT_OF_HINT	#check if uer is out of hints
		
		continue1:
		lw $s1, 4($sp)
		la $s2, user_stars_spaces
		la $s3, user_guesses
		HINT_LOOP:
		
		#load both bytes of strings
		lbu $t1, 0($s1)
		lbu $t2, 0($s2)
		#if the pointer is not a '_' try again
		beq $t2, '_', STORE_HINT

		# add $t0 to both pointers
		addi $s1, $s1, 1	
		addi $s2, $s2, 1
		addi $s3, $s3, 1
		j HINT_LOOP
		
		STORE_HINT:
		sb $t1, 0($s2)
		sb $t1, 0($s3)			# if not a * insert character as hint
		addi $s6, $s6, 1		#make sure no more hints are allowed
		j HINT_PRINT
		
		
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
	
	#decrement round Score here
	subi $s5, $s5, 1
	
	HINT_END:
	#EPILOGUE
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	la $s2, user_stars_spaces
	la $s3, user_guesses
	#RETURN
	jr $ra
	

#-----------------------------Forfeit procedure-----------------------------------#

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
			la $a0, YOUR_ROUNDSCORE_ZERO
			syscall
			
			li $v0, 4
			la $a0, GAME_TALLY
			syscall
			
			#print game tally
			li $v0, 1
			move $a0, $s4
			syscall
			
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
		

#-----------------------------End Forfeit procedure--------------------------------#


#------------------------------Procedure Finds Random Word------------------------#
	WORDFIND:
	#prologue
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	
	# main body
	
	la $a1, wordbank
	#seed random generator
	
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
#---------------------End WordFind Procedure--------------------------------#
	
	
#---------------------Procedure puts in Stars and spaces------------------------#
	ASTERISK:
	#PROLOGUE
	subi $sp, $sp, 8
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	
	#MAIN BODY
		la $s3, user_guesses
		la $s2, user_stars_spaces
		
		li $a1, '*'
		li $a2, '_'
		#counter
		li $t1, 0
		COUNT:				#counts number of characters
		lbu $t3, 0($s1)
		beqz $t3, replace
		addi $s1, $s1, 1
		addi $t1, $t1, 1		#number of characters in $t1
		j COUNT
		#random number of *
		replace:
		la $s0, 4			#generate random number between 0 and 3
		jal RANDOMNUM
		move $t2, $v0			#put random number into $t2
		
		lw $s1, 4($sp)
		
		#counter
		li $t0, 0
		LOOP1:				#Loop to put in *
			
			beq $t0, $t2, dashes	#number of *'s
			move $s0, $t1		#random number for spot in string
			jal RANDOMNUM
			move $t4, $v0		#random spot in $t4
			#addi $t4, $t4, 1
			
			# loop to move pointer to random spot add $a0, $a0, $t4
			LOOPADD:
			 beq $t8, $t4, cont
			 addi $s2, $s2, 1
			 addi $s3, $s3, 1
			 addi $t8, $t8, 1
			 j LOOPADD
			 
			#put * into random spot 
			cont:	
			sb $a1, 0($s2)
			sb $a1, 0($s3)
			addi $t0, $t0, 1
			
			#loop to put pointer back to beginning of string sub $a0, $a0, $t4
			LOOPSUB:
			beq $t8, 0, LOOP1
			subi $s2, $s2, 1
			subi $s3, $s3, 1
			subi $t8, $t8, 1
			j LOOPSUB
		
		# code to put in _
		dashes:
		li $t7, 0 #counter
		LOOP2:
		beq $t7, $t1, exit
		sb $a3, 0($s3)
		lbu $t5, 0($s2)		#takes characters out
		beq $t5, $a1, skips	#if character = * skip
		sb $a2, 0($s2)		#if not put _ into string

		
		skips:
		addi $s2, $s2, 1	#move pointer
		addi $s3, $s3, 1
		addi $t7, $t7, 1	#add to counter
		j LOOP2
		
		exit:
		
			
	#EPILOGUE
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	la $s2, user_stars_spaces
	la $s3, user_guesses
	
	#RETURN
	jr $ra	
#---------------------End Asterisk Procedure---------------------#
	
	
#---------------------Procedure prints spaces between characters----------------#
	PRINTSPACE:
		#prologue
		subi $sp, $sp, 16
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $s2, 8($sp)
		
		#main body
			li $t1, 0
			COUNTER:				#counts number of characters
				lbu $t3, 0($s2)
				beq $t3, ' ', prints
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
				
				li $v0, 4
				la $a0, space
				syscall
				
				#add to counters
				addi $s2, $s2, 1
				addi $t2, $t2, 1
				
				j PLOOP
				
		end1:
		#epilogue
		lw $s2, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		#return
		jr $ra
#---------------------------End PrintSpace procedure---------------------#


#-------------------------Procedure gets random number------------------#
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
#------------------------End RandomNum procedure------------------------------#
	
	LENGTH_COUNTER:
		#PROLOGUE
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		sw $s1, 4($sp)
		#MAIN BODY
			lw $s1, 4($sp)
			li $t1, 0
			COUNT3:				#counts number of characters
			lbu $t3, 0($s1)
			beqz $t3, replace3
			addi $s1, $s1, 1
			addi $t1, $t1, 1		#number of characters in $t1
			j COUNT3
			
			replace3:
			
		
		#EPILOGUE
		lw $s1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		move $v0, $t1
		#RETURN
		jr $ra

#------------------------Procedure to restore space--------------------------#
	RESTORE:
	#PROLOGUE
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#MAIN BODY
	li $t3, 0
	li $t4, ' '
	
	LOOPRESTORE:
		beq $t3, 10, end_restore
		sb $t4, 0($s2)
		sb $t4, 0($s3)
		addi $s3, $s3, 1
		addi $s2, $s2, 1
		addi $t3, $t3, 1
		
		j LOOPRESTORE
	
	end_restore:
		
	#EPILOGUE
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	#RETURN
	jr $ra
	
