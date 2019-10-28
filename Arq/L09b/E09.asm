.data
Out1:	.asciiz "Insira o dividendo: "
Out1.1:	.asciiz "Insira o divisor: "
Out2:	.asciiz "Não é possível fazer a divisão"
Out3:	.asciiz "A quantidade de vezes que o número é divisível é: "

.text
main:
	jal leNumeros
	jal divisao
	jal impressao
	j fim
	
impressao:
	bgtz $t0, impressaoTrue
	la $a0, Out2
	li $v0, 4
	syscall
	jr $ra
impressaoTrue:
	la $a0, Out3
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	jr $ra
	
divisao:
	move $a0, $ra
	jal fStart
	li $t0, 0
divisaoLoop:
	div $s0, $s1
	mfhi $t1
	bnez $t1, return
	mflo $s0
	addi $t0, $t0, 1
	j divisaoLoop	
	
leNumeros:	#Retorna o dividendo em $s0, e o divisor em $s1
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0	
	la $a0, Out1.1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
	jr $ra

fStart:
	subi $sp, $sp, 8
	sw $a0, ($sp)
	jr $ra
return:
	lw $ra, ($sp)
	addi $sp, $sp, 8
	jr $ra
fim:
	li $v0, 10
	syscall