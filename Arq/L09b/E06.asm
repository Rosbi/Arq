.data
Out1:	.asciiz "Insira o índice do N-ésimo elemento: "
Out2:	.asciiz "O N-ésimo elemento é: "

.text
main:
	jal leN
	move $a0, $v0	#coloca em $a0 o número lido
	jal fibb
	jal print
	j fim

print:
	move $a0, $v0
	li $v0, 1
	syscall
	jr $ra

fibb:
	move $a1, $ra
	jal fStart
	blez, $a0, fibbReturn0		#if $a0 <= 0, return 0
	li $t0, 1
	beq $a0, $t0, fibbReturn1	#if $a0 == 1, return 1
	subi $sp, $sp, 4	#armazena $a0 na stack
	sw $a0, ($sp)
	subi $a0, $a0, 1	
	jal fibb		#fibb(n-1)
	subi $sp, $sp, 4	#armazena fibb(n-1) na stack
	sw $v0, ($sp)
	lw $a0, 4($sp)		#pega da stack o valor de $a0
	subi $a0, $a0, 2
	jal fibb		#fibb(n-2)
	lw $t0, ($sp)
	add $v0, $v0, $t0
	addi $sp, $sp, 8	#retorna a stack para a posição anterior
	j return		
fibbReturn0:
	li $v0, 0
	j return
fibbReturn1:
	li $v0, 1
	j return	
	
leN:
	la $a0, Out1
	li $v0, 4
	syscall		#imprime a mensagem pedindo um número para o usuário
	li $v0, 5
	syscall		#lê esse número
	jr $ra
	
fStart:
	subi $sp, $sp, 4
	sw $a1, ($sp)
	jr $ra
return:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
fim:
	li $v0, 10
	syscall