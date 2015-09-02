.data
	word:	.asciiz		"computer"
	
.text
	li $a1, '*'
	li $a2, '_'
	la $a0, word
	jal ASTERISK
	move $a0, $v0
	
	li $v0, 4
	syscall
	
	#la $t9, word
	#li $v0, 4
	#move $a0, $t9
	#syscall
	
	li $v0, 10
	syscall
	
	ASTERISK:
	#PROLOGUE
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	
	#MAIN BODY
		#move $t6, $a0
		#li $v0, 4
		#syscall
		
		#counter
		li $t1, 0
		COUNT:				#counts number of characters
		lbu $t3, 0($a0)
		beqz $t3, replace
		addi $a0, $a0, 1
		addi $t1, $t1, 1		#number of characters in $t1
		j COUNT
		#random number of *
		replace:
		la $s0, 3			#generate random number between 0 and 3
		jal RANDOMNUM
		move $t2, $v0			#put random number into $t2
		addi $t2, $t2, 1		#add 1 to random number so no 0
		
		lw $a0, 4($sp)
		#li $v0, 1
		#move $a0, $t2
		#syscall
		
		#counter
		li $t0, 0
		LOOP1:				#Loop to put in *
			
			beq $t0, $t2, dashes	#number of *'s
			move $s0, $t1		#random number for spot in string
			jal RANDOMNUM
			move $t4, $v0		#random spot in $t4
			#addi $t4, $t4, 1
			
			#li $v0, 1
			#move $a0, $t4
			#syscall
			
			# loop to move pointer to random spot add $a0, $a0, $t4
			LOOPADD:
			 beq $t8, $t4, cont
			 addi $a0, $a0, 1
			 addi $t8, $t8, 1
			 j LOOPADD
			 
			#put * into random spot 
			cont:	
			sb $a1, 0($a0)
			addi $t0, $t0, 1
			
			#loop to put pointer back to beginning of string sub $a0, $a0, $t4
			LOOPSUB:
			beq $t8, 0, LOOP1
			subi $a0, $a0, 1
			subi $t8, $t8, 1
			j LOOPSUB
		
		# code to put in _
		dashes:
		li $t7, 0 #counter
		LOOP2:
		beq $t7, $t1, exit
		lbu $t5, 0($a0)		#takes characters out
		beq $t5, $a1, skip	#if character = * skip
		sb $a2, 0($a0)		#if not put _ into string
		
		skip:
		addi $a0, $a0, 1	#move pointer
		addi $t7, $t7, 1	#add to counter
		j LOOP2
		
		exit:
		
		#move $v0, $s1
			
	#EPILOGUE
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	#return string
	move $v0, $a0
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
