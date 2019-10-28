.data
Out1:	.asciiz "Insira a ordem mxn da matriz: \n"
Out2:	.asciiz "Insira os "
Out2.1:	.asciiz " elementos da matriz:\n"
Out3:	.asciiz "\nMatriz:\n"

.text
main:
	jal lerTamanho
	mul $a0, $v0, $v1
	move $s0, $v0
	jal malloc
	subi $sp, $sp, 12
	sw $v0, 8($sp)	#armazena o ponteiro para a matriz no topo da stack (pMat)
	sw $s0, 4($sp)	#armazena o numero de linhas logo abaixo (nLin)
	sw $v1, 0($sp)	#armazena o numero de clounas no fim (nCol)
	jal leitura
	jal inverteLinhasImpares
	jal escrita
	jal fim

inverteLinhasImpares:
	lw $s0, 8($sp)	#pMat
	lw $s1, 4($sp)	#nLin
	lw $s2, 0($sp)	#nCol
	move $a0, $ra
	jal fStart
	li $s6, 0	#contador de linha
	li $s7, 0	#contador de colunas
inverteLinhasImparesLoop:
	addi $t0, $s6, 2
	bgt $t0, $s1, return
iLILoop1:
	move $a0, $s6
	move $a1, $s7
	move $a2, $s2
	move $a3, $s0
	jal matIndex
	move $t0, $v0
	addi $a0, $s6, 2
	jal matIndex
	lw $t1, ($t0)
	lw $t2, ($v0)
	sw $t2, ($t0)
	sw $t1, ($v0)
	addi $s7, $s7, 1
	blt $s7, $s2, iLILoop1
	li $s7, 0
	addi $s6, $s6, 4
	blt $s6, $s1, inverteLinhasImparesLoop
	j return	
	
lerTamanho:
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	li $v0, 5
	syscall
	move $v1, $v0
	move $v0, $t0
	jr $ra
	
leitura:
	move $a0, $ra
	jal fStart
	lw $s0, 12($sp)	#pMat
	lw $s1, 8($sp)	#nLin
	lw $s2, 4($sp)	#nCol		#em 0($sp) está armazenado $ra
	li $s6, 0	#linha atual (i)
	li $s7, 0	#coluna atual (j)
	la $a0, Out2
	li $v0, 4
	syscall
	mul $a0, $s1, $s2
	li $v0, 1
	syscall
	la $a0, Out2.1
	li $v0, 4
	syscall
leituraLoop:
	move $a0, $s6
	move $a1, $s7
	move $a2, $s2
	move $a3, $s0
	jal matIndex
	move $t0, $v0
	li $v0, 5
	syscall
	sw $v0, ($t0)
	addi $s7, $s7, 1
	blt $s7, $s2, leituraLoop
	li $s7, 0
	addi $s6, $s6, 1
	blt $s6, $s1, leituraLoop
	jal return
	
escrita:
	move $a0, $ra
	jal fStart
	la $a0, Out3
	li $v0, 4
	syscall	
	lw $s0, 12($sp)	#pMat
	lw $s1, 8($sp)	#nLin
	lw $s2, 4($sp)	#nCol		#em 0($sp) está armazenado $ra
	li $s6, 0	#linha atual (i)
	li $s7, 0	#coluna atual (j)
escritaLoop:
	move $a0, $s6
	move $a1, $s7
	move $a2, $s2
	move $a3, $s0
	jal matIndex
	lw $a0, ($v0)
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	addi $s7, $s7, 1
	blt $s7, $s2, escritaLoop
	li $s7, 0
	addi $s6, $s6, 1
	li $a0, 10
	li $v0, 11
	syscall
	blt $s6, $s1, escritaLoop
	jal return
			
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
