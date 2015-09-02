.data

	wordbank:	.asciiz  "computer" "game" "science" "word" "hangman" "Wordsoup" "quadrant" "gigantic"

.text
	la $s0, wordbank
	#seed random generator
	li $v0, 30
	syscall
	#a0 has sort of ranom number based on system time
	
	#a1 maximum value
	li $a1, 8
	
	#random number generation
	li $v0, 42
	syscall
	#a0 has your random number
	
	#li $v0, 1
	#syscall
	
	#if random number is 0 just print the address of wordbank
	beq $a0, $zero, first
	# if not continue down to rest of code
	bne $a0, $zero, find
	
	#print out the address of wordbank
	first:
	li $v0, 4
	move $a0, $s0
	syscall
	
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
		# put the address of the word into a0
		move $a0, $s0
		#print out the word
		li $v0, 4
		syscall

	
