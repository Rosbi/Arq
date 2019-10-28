.data
Out1:	.asciiz "Insira o tamanho do vetor: "
Out2:	.asciiz "Insira os elementos do vetor:\n"
Out3:	.asciiz " ocorre "
Out3.1:	.asciiz " vez(es)\n"

.text
main:
	jal leTamVet
	move $s0, $v0
	jal malloc
	move $s1, $v0
	jal leVetor
	jal verifica
	jal imprimeResultado
	j end
	
imprimeResultado:
	subi $t0, $s0, 4
	subi $t1, $s1, 4
	li $t2, 0
imprimeResultadoLoop:
	addi $t2, $t2, 1
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	lw $t9, ($t1)
	bltz $t9, imprimeResultadoLoop
	l.s $f12, ($t0)
	li $v0, 2
	syscall
	la $a0, Out3
	li $v0, 4
	syscall
	move $a0, $t9
	li $v0, 1
	syscall
	la $a0, Out3.1
	li $v0, 4
	syscall
	blt $t2, $s7, imprimeResultadoLoop
	jr $ra
	
verifica:
	move $a0, $ra
	jal fStart
	li $t9, 0
	li $t8, 0
	li $t7, 0
	move $t0, $s0
	move $t1, $s1
	l.s $f4, ($s0)
verificaLoop:
	addi $t9, $t9, 1
	l.s $f6, ($t0)
	c.eq.s $f4, $f6
	bc1t verificaIgual
	addi $t0, $t0, 4
	addi $t1, $t1, 4
verificaIf:
	blt $t9, $s7, verificaLoop
	mul $t0, $t7, 4
	add $t1, $t0, $s1
	sw $t8, ($t1)
verificaIfLoop:
	addi $t7, $t7, 1
	mul $t0, $t7, 4
	add $t1, $t0, $s1
	lw $t0, ($t1)
	bltz $t0, verificaIfLoop
	mul $t0, $t7, 4
	add $t0, $t0, $s0
	move $t9, $t7
	li $t8, 0
	l.s $f4, ($t0)
	blt $t7, $s7, verificaLoop
	j return
verificaIgual:
	addi $t8, $t8, 1
	li $t5, -1
	sw $t5, ($t1)
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	j verificaIf
	
leVetor:
	la $a0, Out2
	li $v0, 4
	syscall
	li $t0, 0
	move $t1, $s0
leVetorLoop:
	li $v0, 6
	syscall
	s.s $f0, ($t1)
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	blt $t0, $s7, leVetorLoop
	jr $ra
	
leTamVet:
	move $a0, $ra
	jal fStart
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s7, $v0
	mul $a0, $v0, 4
	jal malloc
	j return 
	
malloc:
	li $v0, 9
	syscall
	jr $ra
fStart:
	subi $sp, $sp, 4
	sw $a0, ($sp)
	jr $ra
return:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
end:
	li $v0, 10
	syscall
