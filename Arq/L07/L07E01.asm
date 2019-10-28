.data
Mat:	.space 48 #4x3 inteiros
Vet:	.space 12 #3x1 inteiros
Res:	.space 12

.text
main:	add $t0, $zero, $zero
	add $t1, $zero, $zero
	la $a0, Mat
	li $a1, 4
	li $a2, 3
	jal leitura
	la $a0, Vet
	li $a1, 3
	li $a2, 1
	jal leitura
	la $a0, Mat
	li $a1, 4
	li $a2, 3
	jal escrita
	la $a0, Vet
	li $a1, 3
	li $a2, 1
	jal escrita
	li $a1, 4
	li $a2, 3
	jal multiplica
	la $a0, Res
	li $a1, 4
	li $a2, 1
	jal escrita
	li $v0, 10
	syscall
	
indice:	#t0: cont linhas, t1: cont colunas, a2: qtd linhas, a3: endereço da matriz
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra
	
leitura:
	subi $sp, $sp, 4 #espaço para 1 int na stack
	sw $ra, ($sp)
	move $a3, $a0
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
	
escrita:
	li $t0, 0
	li $t1, 0
	subi $sp, $sp, 4
	sw $ra, ($sp)
	move $a3, $a0
e:	jal indice
	lw $a0, ($v0)
	li $v0, 1
	syscall
	la $a0, 32
	li $v0, 11
	syscall
	addi $t1, $t1, 1
	blt $t1, $a2, e
	la $a0, 10	#ASCII para \n
	li $v0, 11
	syscall
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, e
	li $t0, 0
	lw $ra, ($sp)
	addi $sp, $sp, 4
	la $a0, 10	#ASCII para \n
	li $v0, 11
	syscall
	move $v0, $a3
	jr $ra
	
multiplica:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	li $t2, 0	#cont linhas
	li $t3, 0	#cont colunas
	li $s3, 0
	#move $s4, $a1
	#move $s5, $a2
loop:	la $a3, Mat
	move $t0, $t2
	move $t1, $t3
	jal indice
	lw $s0, ($v0)
	la $a3, Vet
	li $t1, 0
	move $t9, $a2
	li $a2, 1
	move $t0, $t3
	jal indice
	move $a2, $t9
	lw $s1, ($v0)
	mul $s2, $s0, $s1
	add $s3, $s3, $s2
	addi $t3, $t3, 1
	blt $t3, $a2, loop
	li $t3, 0
	li $t0, 0
	move $t1, $t2
	la $a3, Res
	jal indice
	sw $s3, ($v0)
	addi $t2, $t2, 1
	li $s3, 0
	blt $t2, $a1, loop
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra