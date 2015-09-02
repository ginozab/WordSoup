.data
	ast:	.asciiz		"_*__*_"
	space:	.asciiz		" "
	
.text

	la $a1, ast
	la $a2, space
	jal PRINTSPACE
	
	li $v0, 10
	syscall
	
	
	PRINTSPACE:
		#prologue
		subi $sp, $sp, 16
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		sw $a2, 12($sp)
		
		#main body
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