.data
	fort:	.asciiz		"forfeit"
	hints:	.asciiz		"hint"
	guesss:	.asciiz		"guess"
	else:	.asciiz		"else"
.text
	
	

	#game play structure
	li $v0, 12
	syscall
	
	beq $v0, '!', guess
	beq $v0, '?', hint
	beq $v0, '.', forfeit
	
	li $v0, 4
	la $a0, else
	syscall
	j end
	
	forfeit:
	li $v0, 4
	la $a0, fort
	syscall
	j end
	
	hint:
	li $v0, 4
	la $a0, hints
	syscall
	j end
	
	guess:
	li $v0, 4
	la $a0, guesss
	syscall
	j end
	
	end:
	li $v0, 10
	syscall
	
	