.data
Out1:	.asciiz "Insira a quantidade de alunos: "
Out2:	.asciiz "A media do aluno "
Out2.1:	.asciiz " é "
Out2.1A:	.asciiz ", e ele foi aprovado\n"
Out2.1R:	.asciiz ", e ele foi reprovado\n"
Out3:	.asciiz "A média da sala é "
Out4:	.asciiz "\nQuantidade de alunos aprovados: "
Out4.1:	.asciiz "\nQuantidade de alunos reprovados: "
Out5:	.asciiz "\nInsira as 3 notas do aluno "
Out5.1:	.asciiz ":\n"
Out6:	.asciiz "\n------------------------------------------------\n"
Flt3:	.float 3.0
Flt6:	.float 6.0

#$s0 = endereço da matriz
#$s1 = numero de alunos
#$s2 = quantidade de aprovados
#$f22 = média da sala

.text
main:
	jal leTamanho
	move $s1, $v0
	li $t0, 3
	mul $a0, $s1, $t0
	jal malloc
	move $s0, $v0
	jal leNotas
	jal imprimeSala
	j fim
	
imprimeSala:
	la $a0, Out6
	li $v0, 4
	syscall
	la $a0, Out3
	li $v0, 4
	syscall
	mtc1 $s1, $f4
	cvt.s.w $f4, $f4
	div.s $f12, $f22, $f4
	li $v0, 2
	syscall
	la $a0, Out4
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	la $a0, Out4.1
	li $v0, 4
	syscall
	sub $a0, $s1, $s2
	li $v0, 1
	syscall
	jr $ra
	
leNotas:
	move $a0, $ra
	jal fStart
	li $t0, 0	#numero da linha
	li $t1, 0	#numero da coluna
leNotasLoop:
	la $a0, Out5
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, Out5.1
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	move $a0, $t0
	move $a1, $t1
	move $a2, $s1
	move $a3, $s0
	jal matIndex
	s.s $f0, ($v0)
	mov.s $f20, $f0		#$f20 = soma das notas do aluno n
	li $v0, 6
	syscall
	addi $a0, $a0, 1
	jal matIndex
	s.s $f0, ($v0)
	add.s $f20, $f20, $f0
	li $v0, 6
	syscall
	addi $a0, $a0, 1
	jal matIndex
	s.s $f0, ($v0)
	add.s $f20, $f20, $f0
	l.s $f4, Flt3
	div.s $f20, $f20, $f4
	
	la $a0, Out2
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, Out2.1
	li $v0, 4
	syscall
	mov.s $f12, $f20
	li $v0, 2
	syscall
	
	add.s $f22, $f22, $f20
	l.s $f4, Flt6
	c.lt.s $f20, $f4
	bc1t leNotasLoopReprovado
	addi $s2, $s2, 1
	la $a0, Out2.1A
	li $v0, 4
	syscall
leNotasLoopC:
	addi $t1, $t1, 1
	li $t0, 0
	blt $t1, $s1, leNotasLoop
	j return
leNotasLoopReprovado:
	la $a0, Out2.1R
	li $v0, 4
	syscall
	j leNotasLoopC
	
leTamanho:
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	jr $ra

malloc:	#aloca a quantidade de bytes em $a0
	li $v0, 9
	syscall
	jr $ra
fStart:	#guarda o $ra (se encontra em $a0) na stack
	subi $sp, $sp, 4
	sw $a0, ($sp)
	jr $ra
return:	#carrega o $ra e pula para ele
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
matIndex:	#retorna o elemento no indice [i][j] de Mat ()
		#$a0 = linhaAtual, $a1 = colunaAtual, $a2 = nCol, $a3 = endereçoMat
	mul $v0, $a0, $a2
	add $v0, $v0, $a1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra
fim:
	li $v0, 10
	syscall
