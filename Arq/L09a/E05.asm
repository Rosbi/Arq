.data
Out1:	.asciiz "Insira o cpf (xxxxxxxxx-xx): "
OutV:	.asciiz "\nO cpf é valido"
OutF:	.asciiz "\nO cpf é inválido"
	#.align 2
CpfStr:	.asciiz "xxxxxxxxx-xx"
	.align 2
CpfVet:	.space 44

.text
main:
	jal leCpf
	jal atoi
	jal verificaCpf
	j fim
	
verificaCpf:
	move $a0, $ra
	jal fStart
	la $a0, CpfVet
	li $t1, 10	#contador
	li $t3, 0	#soma
	jal verificaCpfL1
	move $s0, $v0
	la $a0, CpfVet
	li $t1, 11
	li $t3, 0
	jal verificaCpfL1
	move $s1, $v0
	la $a0, CpfVet
	lw $t0, 36($a0)
	lw $t1, 40($a0)
	bne $t0, $s0, verificaCpfF
	bne $t1, $s1, verificaCpfF
	la $a0, OutV
	li $v0, 4
	syscall
	j return
verificaCpfF:
	la $a0, OutF
	li $v0, 4
	syscall
	j return
verificaCpfL1:
	lw $t2, ($a0)
	mul $t2, $t2, $t1
	add $t3, $t3, $t2
	subi $t1, $t1, 1
	addi $a0, $a0, 4
	li $t2, 2
	bge $t1, $t2, verificaCpfL1
	li $t2, 11
	div $t3, $t2
	mfhi $t2
	li $t3, 2
	blt $t2, $t3, verificaCpfL1If1
	li $t3, 11
	sub $v0, $t3, $t2
	jr $ra
verificaCpfL1If1:
	li $v0, 0
	jr $ra

atoi:
	move $a0, $ra
	jal fStart
	la $a0, CpfStr
	la $a1, CpfVet
atoiL:
	lb $t0, ($a0)
	beqz $t0, atoiReturn
	subi $t0, $t0, 48
	addi $a0, $a0, 1
	li $t1, 9
	bgt $t0, $t1, atoiL
	bltz $t0, atoiL
	sw $t0, ($a1)
	addi $a1, $a1, 4
	j atoiL
atoiReturn:
	li $t0, -1
	sw $t0, ($a1)
	j return
	
leCpf:
	la $a0, Out1
	li $a1, 13
	li $v0, 4
	syscall
	la $a0, CpfStr
	li $v0, 8
	syscall
	#sw $v0, CpfStr
	jr $ra

fStart:	#guarda o $ra (se encontra em $a0) na stack
	subi $sp, $sp, 4
	sw $a0, ($sp)
	jr $ra
return:	#carrega o $ra e pula para ele
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
fim:
	li $v0, 10
	syscall