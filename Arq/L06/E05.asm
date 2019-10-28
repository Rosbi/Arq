.data
outstr:	.asciiz "Insira a string: "
outcha:	.asciiz "Insira o caracter: "
outint:	.asciiz "\nInsira a posicao: "
inStr:	.space 100
inCha:	.byte 'a'
inInt:	.align 2
	.word 0
naoTem:	.asciiz "Nao encontrado: "
tem:	.asciiz "Caracter encontrado na posicao "

.text
main:	la $a0, outstr	
	li $v0, 4
	syscall		#imprime a mensagem pra inserção de string
	la $a0, inStr
	li $a1, 100
	li $v0, 8
	syscall		#lê string de 100 caracteres
	la $a0, outcha
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	sb $v0, inCha
	la $a0, outint
	li $v0, 4
	syscall
	la $a0, inInt
	la $v0, 5
	syscall
	sw $v0, inInt
	la $a0, inStr
	lb $a1, inCha
	lw $a2, inInt
	add $t0, $zero, $zero
offset:	beqz $a2, busca
	subi $a2, $a2, 1
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j offset
busca:	lb $t1, ($a0)
	beqz $t1, notFound
	beq $t1, 10, notFound
	beq $t1, $a1, found
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j busca

notFound:
	la $a0, naoTem
	li $v0, 4
	syscall
	j fim
found:	la $a0, tem
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
fim:
	li $v0, 10
	syscall