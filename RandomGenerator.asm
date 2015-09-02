.data
	#wordbank:	.asciiz  "computer" "game" "science" "word" "hangman" "Wordsoup" "quadrant" "gigantic"
	space:		.asciiz		" "
.text
	#generate random number
	la $s1, 8
	jal RANDOMNUM
	move $a0, $v0
	
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	la $s1, 3
	jal RANDOMNUM
	move $a0, $v0
	
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	la $s1, 5
	jal RANDOMNUM
	move $a0, $v0
	
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	RANDOMNUM:
		#PROLOGUE
		subi $sp, $sp, 8
		sw $ra, 0($sp)
		sw $a1, 4($sp)
		
		
		#MAIN BODY
		li $v0, 30
		syscall
		#a0 has sort of ranom number based on system time
	
		#a1 maximum value
		move $a1, $s1
	
		#random number generation
		li $v0, 42
		syscall
		#a0 has your random number
		
		#return random number
		move $v0, $a0
		
		#EPILOGUE
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		#RETURN
		jr $ra
		
	
