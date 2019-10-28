.data
Vet:	.space 12 #3x1 inteiros
Res:	.space 16 #4x1 inteiros
Ent1:	.asciiz "Insira o os indices i e j da matriz:\n"
Ent2:	.asciiz "Insira os "
Ent3:	.asciiz " elementos da matriz\n"
Ent4:	.asciiz "\nLinhas nulas: "
Ent5:	.asciiz "\nColunas Nulas: "

.text
main:	jal leTamanho
	mul $a0, $s0, $s1
	sll $a0, $a0, 2
	jal malloc
	move $s2, $v0	#$s2 recebe o endereço de memória alocado
	move $a0, $s2	#passa os
	move $a1, $s0	#	 valores para os
	move $a2, $s1	#		        registradores de argumento
	jal leitura
	move $a0, $s2
	jal escrita
	move $a0, $s2
	jal linColNulas
	li $v0, 10
	syscall
	
leTamanho:	#lê os indices i e j da matriz
	la $a0, Ent1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0	#$s0 = linhas
	li $v0, 5
	syscall
	move $s1, $v0	#$s1 = colunas
	jr $ra	
	
malloc:		#aloca $a0 bytes de memória
	li $v0, 9
	syscall
	jr $ra
	
start:		#armazena $ra (guardado em $t0) na stack
	subi $sp, $sp, 4	#NOTA:
	sw $t0, ($sp)		#essa função serve meramente para melhorar a legibilidade,
	jr $ra			#e não tem outra utilidade
return:		#volta para a função anterior e atualiza o stack pointer
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
indice:		#retorna o endereço de memória de M[$t0][$t1] ($a3 == *M, $a2 == numeroColunas) 
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra
	
leitura:	#lê a matriz $a0[$a1][$a2]
	mul $t0, $a1, $a2
	add $t1, $zero, $zero
	subi $sp, $sp, 4 #espaço para 1 int na stack
	sw $ra, ($sp)
	move $a3, $a0
	la $a0, Ent2
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, Ent3
	li $v0, 4
	syscall
	add $t0, $zero, $zero
le:	li $v0, 5
	syscall
	move $t2, $v0
	jal indice
	sw $t2, ($v0)
	addi $t1, $t1, 1
	blt $t1, $a2, le
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, le
	li $t0, 0
	la $a0, 10	#ASCII para nova linha
	li $v0, 11
	syscall
	lw $ra ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra
	
escrita:	#imprime a matriz $a0[$a1][$a2]
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
e:	move $t7, $v0
	jal indice
	lw $a0, ($v0)
	li $v0, 1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	blt $t1, $a2, e
	la $a0, 10	#ASCII para '\n'
	li $v0, 11
	syscall
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, e
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	move $v0, $a3
	jr $ra

linColNulas:	#calcula a quantidade de colunas da matriz $a0[$a1][$a2]
	move $t0, $ra
	jal start
	li $t2, 0	#contador de linhas nulas
	li $t3, 0	#contador de colunas nulas
	li $t0, 0	#contador de linhas
	li $t1, 0	#contador de colunas
	move $a3, $s2	#move para o parametro da função indice
loop:	jal indice
	lw $t4, ($v0)	#$t4 = M[i][j]
	bnez $t4, next	#se $t4 não for nulo, logo a linha não é nula, portanto pura para a próxima linha
	addi $t1, $t1, 1	#se $t4 for 0, verifica a próxima coluna
	bne $t1, $a2, loop
	addi $t2, $t2, 1	#se a linha for nula, adiciona no contador e vai para a próxima
next:	addi $t0, $t0, 1
	li $t1, 0
	bne $t0, $a1, loop	#se não for a última linha, vai para a próxima
	li $t0, 0		#caso contrário, volta para o início da matriz
	li $t1, 0		#	e conta as colunas
loop1:	jal indice		#		seguindo o mesmo processo
	lw $t4, ($v0)
	bnez $t4, next1
	addi $t0, $t0, 1
	bne $t0, $a1, loop1
	addi $t3, $t3, 1
next1:	addi $t1, $t1, 1
	li $t0, 0
	bne $t1, $a2, loop1
print:	la $a0, Ent4		#imprime a quantidade de linhas e colunas nulas e
	li $v0, 4		#	volta para a main
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, Ent5
	li $v0, 4
	syscall
	move $a0, $t3
	li $v0, 1
	syscall
	j return
