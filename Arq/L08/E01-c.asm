.data
Out1:	.asciiz "Insira a ordem mxn da matriz: \n"
Out2:	.asciiz "Insira os "
Out2.1:	.asciiz " elementos da matriz:\n"
Out3:	.asciiz "\nMatriz:\n"
Out4:	.asciiz "Soma dos primos: "

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
	jal somaPrimos
	jal escrita
	jal fim

somaPrimos:
	lw $s0, 8($sp)	#pMat
	lw $s1, 4($sp)	#nLin
	lw $s2, 0($sp)	#nCol
	move $a0, $ra
	jal fStart
	li $s5, 0	#soma dos primos
	li $s6, 0	#contLin
	li $s7, 0	#contCol
somaPrimosLoop:
	move $a0, $s6
	move $a1, $s7
	move $a2, $s2
	move $a3, $s0
	jal matIndex
	lw $a0, ($v0)
	jal ePrimo
	bnez $v0, somaPrimosAdd
somaPrimosNext:
	addi $s7, $s7, 1
	blt $s7, $s2, somaPrimosLoop
	li $s7, 0
	addi $s6, $s6, 1
	blt $s6, $s1, somaPrimosLoop
	la $a0, Out4
	li $v0, 4
	syscall
	move $a0, $s5
	li $v0, 1
	syscall
	j return
somaPrimosAdd:
	add $s5, $s5, $a0
	j somaPrimosNext

ePrimo:	#$a0 é o numero a ser verificado
	li $t0, 1
	li $t1, -2
ePrimoLoop:
	div $a0, $t0
	mfhi $t9
	bnez $t9, ePrimoLoopContinue
	addi $t1, $t1, 1
ePrimoLoopContinue:
	addi $t0, $t0, 1
	ble $t0, $a0, ePrimoLoop
	bgtz $t1, ePrimoFalse
	li $v0, 1
	jr $ra
ePrimoFalse:
	li $v0, 0
	jr $ra

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
