.data
Out1:	.asciiz "Insira a ordem nxn da matriz: \n"
Out2:	.asciiz "Insira os "
Out2.1:	.asciiz " CARACTERES da matriz:\n"
Out3:	.asciiz "\nMatriz:\n"
Out4:	.asciiz "\nNao existem palindromos na matriz"
Out4.1:	.asciiz "\nExiste(m) palindromo(s) na matriz"

.text
main:
	jal lerTamanho
	mul $a0, $v0, $v0
	move $s0, $v0
	jal malloc
	subi $sp, $sp, 12
	sw $v0, 8($sp)	#armazena o ponteiro para a matriz no topo da stack (pMat)
	sw $s0, 4($sp)	#armazena o numero de linhas logo abaixo (nLin)
	sw $s0, 0($sp)	#armazena o numero de clounas no fim (nCol)
	jal leitura
	jal escrita
	jal buscaPalindromos
	jal fim

buscaPalindromos:
	lw $s0, 8($sp)
	lw $s1, 4($sp)
	move $a0, $ra
	jal fStart
	li $s6, 0	#contador de linhas/colunas
buscaPalindromosLoop:
	move $a0, $s0
	move $a1, $s6
	move $2, $s1
	jal linhaPalindromo
	bnez $v0, return
	move $a0, $s0
	move $a1, $s6
	move $2, $s1
	jal colunaPalindromo
	bnez $v0, return
	addi $s6, $s6, 1
	blt $s6, $s1, buscaPalindromosLoop
	la $a0, Out4
	li $v0, 4
	syscall
	j return

linhaPalindromo:	#$a0 = pMat, $a1 = linha atual, $a2 = nCol
	move $a3, $a0
	move $t0, $a1
	move $a0, $ra
	jal fStart
	move $a0, $t0
	li $t0, 2
	div $a2, $t0
	mflo $t1
	addi $t1, $t1, 1
	li $t0, 0	#contador da coluna
linhaPalindromoLoop:
	move $a1, $t0
	jal matIndex
	lw $t2, ($v0)
	sub $a1, $a2, $t0
	subi $a1, $a1, 1
	jal matIndex
	lw $t3, ($v0)
	li $v0, 0
	bne $t2, $t3, return
	addi $t0, $t0, 1
	blt $t0, $a2, linhaPalindromoLoop
	la $a0, Out4.1
	li $v0, 4
	syscall
	li $v0, 1
	syscall
	j return
colunaPalindromo:	#$a0 = pMat, $a1 = coluna atual, $a2 = nCol
	move $a3, $a0
	move $a0, $ra
	jal fStart
	li $t0, 2
	div $a2, $t0
	mflo $t1
	addi $t1, $t1, 1
	li $t0, 0	#contador da linha
colunaPalindromoLoop:
	move $a0, $t0
	jal matIndex
	lw $t2, ($v0)
	sub $a0, $a2, $t0
	subi $a0, $a0, 1
	jal matIndex
	lw $t3, ($v0)
	li $v0, 0
	bne $t2, $t3, return
	addi $t0, $t0, 1
	blt $t0, $a2, colunaPalindromoLoop
	la $a0, Out4.1
	li $v0, 4
	syscall
	li $v0, 1
	syscall
	j return
	
lerTamanho:
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
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
	li $v0, 12
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
	li $v0, 11
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
