.data
out:	.asciiz "Interseccao: "
virgula:.asciiz ", "
A:	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
B:	.word 1, 20, 8, 4, 1, 6, 7
sizeA:	.word 15
sizeB:	.word 7
Inter:	.align 2
	.space 28

.text
main:	la $s0, B
	la $s1, A
	la $s2, Inter
	lw $t4, sizeB
	addi $s3, $zero, 0	#tamanho do vetor Inter
	
loopB:	lw $a0, 0($s0)
	addi $s0, $s0, 4
	subi $t4, $t4, 1
	jal loopA
	beqz $t4, print
	j loopB

loopA:	move $t1, $s1
	lw $t3, sizeA
lA1:	lw $t0, ($t1)
	addi $t1, $t1, 4
	subi $t3, $t3, 1
	beq $t0, $a0, loopI
	bnez $t3, lA1
	jr $ra
	
loopI:	move $t2, $s2
	beqz $s3, lINew
	addiu $t3, $s3, 0
lI1:	lw $t0, ($t2)
	subi $t3, $t3, 1
	addiu $t2, $t2, 4
	beq $a0, $t0, loopB
	beqz $t3, lINew
	j lI1
lINew:	sw $a0, ($t2)
	addi $s3, $s3, 1
	jr $ra

print:	la $a0, out
	li $v0, 4
	syscall
p1:	beqz $s3, fim
	subi $s3, $s3, 1
	lw $a0, ($s2)
	li $v0, 1
	syscall
	addiu $s2, $s2, 4
	la $a0, virgula
	li $v0, 4
	syscall
	j p1

fim:	li $v0, 10
	syscall