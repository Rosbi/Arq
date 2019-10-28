.data
input:	.asciiz "Insira o numero a ser checado: "
outT:	.asciiz "\n Palindromo"
outF:	.asciiz "\n Nao palindromo"

.text
main:	jal printI
	jal scanI
	move $s0, $v0
	
palin:	addiu $t1, $zero, 10
	addiu $t0, $zero, 0
pCont:	div $s0, $t1
	mflo $t2
	addi $t0, $t0, 1
	mul $t1, $t1, 10
	bnez $t2, pCont
	addi $s1, $zero, 0
	move $t2, $s0
pInvrt:	div $t2, $t2, 10
	mfhi $t1
	subi $t0, $t0, 1
	mul $s1, $s1, 10
	#mfhi $t0
	add $s1, $s1, $t1
	bnez $t0, pInvrt
checa:	beq $s0, $s1, true
false:	la $a0, outF
	j printO
true:	la $a0, outT

printO:	li $v0, 4
	syscall
fim:	li $v0, 10
	syscall
	
printI:	la $a0, input
	li $v0, 4
	syscall
	jr $ra
	
scanI:	li $v0, 5
	syscall
	jr $ra