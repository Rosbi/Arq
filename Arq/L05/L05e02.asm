.data
SaidA: 	.asciiz "Soma VetA: "
SaidB:	.asciiz "\nSoma VetB: "
VetA:	.word 1, 2, 1, 2, 1, 2, 1, 2, 1, 2
VetB:	.word 3, 4, 3, 4, 3, 4, 3, 4, 3, 4

.text
main:	la $s0, VetA
	addiu $s1, $zero, 1	#contador da posição dos vetores
	addiu $a1, $zero, 0	#guarda temporariamente a soma
	addiu $t2, $zero, 11
	
readarray:	lw $a0, 0($s0)
		addiu $t1, $zero, 21
		beq $s1, $t1, print
		beq $s1, $t2, trocaVet
		addiu $t1, $zero, 2
		div $s1, $t1
		mfhi $t1
		beqz $t1, somar
addarray:	addiu $s0, $s0, 4
		addiu $s1, $s1, 1
		j readarray

somar:	add $a1, $a1, $a0
	j addarray

trocaVet:	move $s2, $a1	#$s2 armazena a soma de VetA
		addiu $a1, $zero, 0
		la $s0, VetB
		addiu $s1, $s1, 1
		addiu $t2, $t2, 11
		j readarray

print:	la $a0, SaidA
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	la $a0, SaidB
	li $v0, 4
	syscall
	move $a0, $a1
	li $v0, 1
	syscall
	
fim:	li $v0, 10
	syscall
