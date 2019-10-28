.data
Out1:	.asciiz "Insira N e P do arranjo:\n"
Out2:	.asciiz "A quantidade de arranjos é "
Out3:	.asciiz "Não é possível calcular o fatorial de números negativos"

.text
main:
	jal leNumeros	#$v0=P, $v1=N
	bgt $v0, $v1, erro	#if (P>N), exit
	bltz $v1, erro		#if (N<0), exit
	move $a0, $v1
	sub $s0, $v1, $v0	#$s0 = n-p
	jal fatorial
	move $s1, $v0	#$s1 = n!
	move $a0, $s0
	jal fatorial
	move $a1, $v0	#$a1 = (n-p)!
	move $a0, $s1
	jal arranjos
	j fim
	
arranjos:	#$a0 = n!, $a1 = (n-p)!
		#transforma os valores em float, e calcula a divisão
	mtc1 $a0, $f4
	cvt.s.w $f4, $f4
	mtc1 $a1, $f6
	cvt.s.w $f6, $f6
	div.s $f12, $f4, $f6
	la $a0, Out2
	li $v0, 4
	syscall
	li $v0, 2
	syscall
	jr $ra
	
erro:
	la $a0, Out3
	li $v0, 4
	syscall
	j fim
	
leNumeros:	#Retorna P em $v0, e N em $v1
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $v1, $v0
	li $v0, 5
	syscall
	jr $ra

fatorial:	#a0!
	move $t0, $a0
	move $a0, $ra
	jal fStart
	move $a0, $t0
	subi $sp, $sp, 8
	sw $a0, ($sp)
	li $t0, 1
	ble $a0, $t0, returnFact1
	subi $a0, $a0, 1
	jal fatorial
	lw $t0, ($sp)
	mul $v0, $v0, $t0
	addi $sp, $sp, 8
	j return
returnFact1:
	addi $sp, $sp, 8
	li $v0, 1
	j return

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