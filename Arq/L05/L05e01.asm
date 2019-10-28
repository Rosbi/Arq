.data
Scan: 	.asciiz "Insira um valor: "
newline:.asciiz "\n"
X:	.align 2
	.space 60
Y:	.align 2
	.space 60
arraysize:	.word 15

.text
main:	la $s0, X
	addi $s1, $zero, 0
	lw $s2, arraysize
	addi $t3, $zero, 0
	la $s3, Y
	addi $s4, $zero, 0

scanarray:	jal scan
		sw $v0, 0($s0)
		addiu $s0, $s0, 4
		addiu $s1, $s1, 1
		add $a0, $v0, $zero
		jal primo
		bne $s1, $s2, scanarray
		j printY

scan:	la $a0, Scan
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	jr $ra
	
primo:	move $t0, $a0
	move $t1, $t0
	li $t2, 1
primo1:	subi $t1, $t1, 1
	ble $t1, $t2, true
	div $t0, $t1
	mfhi $t3
	beqz $t3, false
	j primo1
false:	jr $ra
true:	sw $a0, 0($s3)
	addi $s3, $s3, 4
	addi $s4, $s4, 1
	jr $ra
	
printY:	blez $s4, fim
	subi $s4, $s4, 1
	subi $s3, $s3, 4
	lw $a0, 0($s3)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	j printY
	
fim:	li $v0, 10
	syscall
