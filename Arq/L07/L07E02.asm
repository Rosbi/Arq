.data
Vet:	.space 12 #3x1 inteiros
Res:	.space 16 #4x1 inteiros
Ent1:	.asciiz "Insira o tamanho da matriz quadratica: \n"
Ent2:	.asciiz "Insira os "
Ent3:	.asciiz " elementos da matriz\n"
Ent4:	.asciiz "\nA matriz é permutação"
Ent5:	.asciiz "\nNão é matriz permutação"

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
	jal matPermuta
	li $v0, 10
	syscall
	
leTamanho:	#lê os indices i e j da matriz
	la $a0, Ent1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0	#$s0 = linhas
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
	#la $a0, 10	#ASCII para nova linha
	#li $v0, 11
	#syscall
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

matPermuta:	#verifica se a matriz $a0[$a1][$a2] é permutação
	move $t0, $ra
	jal start
	move $a3, $a0
	li $t0, 0	#contador de linhas
	li $t1, 0	#contador de colunas
	li $t2, 0	#contador temporátio de linhas
	li $t3, 0	#contador de numeros nao nulos
loop1:	jal indice
	lw $t4, ($v0)
	li $t5, 1
	beq $t4, $t5, vasculhaColuna
	bnez $t4, false
	addi $t1, $t1, 1
	blt $t1, $a2, loop1
next:	beqz $t3, false
	li $t1, 0
	addi $t0, $t0, 1
	li $t3, 0
	blt $t0, $a1, loop1
	j true
vasculhaColuna:
	li $t5, 1
	bgt $t3, $t5, false
	addi $t3, $t3, 1
	move $t2, $t0
	li $t0, 0
loop2:	jal indice
	lw $t9, ($v0)
	li $t5, 1
	beq $t9, $t5, add1
	bnez $t9, false
	addi $t0, $t0, 1
	blt $t0, $a1, loop2
	move $t0, $t2
	addi $t1, $t1, 1
	li $t3, 1
	blt $t1, $a2, loop1
	j next
add1:	addi $t3, $t3, 1
	addi $t0, $t0, 1
	li $t5, 2
	ble $t3, $t5, loop2
	j false
false:	la $a0, Ent5
	li $v0, 4
	syscall
	j return
true:	la $a0, Ent4
	li $v0, 4
	syscall
	j return
