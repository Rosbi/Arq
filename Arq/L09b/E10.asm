.data
Out1: .asciiz "Digite o tamanho NxN da matriz: "
Out2: .asciiz "Insira os elementos da matriz:\n"

.text
main:
	jal leitura
	
leitura:

	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	move $a0, $t0
	sll $a0, $a0, 2
	li $v0, 9
	syscall
	move $t7, $v0
	move $a3, $t7
	move $a1, $t0
	move $a2, $a1
	li $t1, 0
	li $t0, 0
	la $a0, Out2
	li $v0, 4
	syscall

loopMatriz:
	li $v0, 6
	syscall
	jal matIndex
	s.s $f0, ($v0)
	addi $t1, $t1, 1
	blt $t1, $a2, loopMatriz
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $a1, loopMatriz
	li $t0, 0
	move $v0, $a3
	li $t1, 1
	li $t0, 0
	
primeiro:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $a2, primeiro
	addi $t0, $t0, 1
	move $t1, $t0
	addi $t1, $t1, 1
	blt $t0, $a1, primeiro
	jal impressao
	li $t0, 0
	li $t1, 0
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
segundo:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t4, segundo
	addi $t0, $t0, 1
	li $t1, 0
	subi $t4, $t4, 1
	bgt $t4, 0, segundo
	jal impressao
	li $t1, 1
	li $t0, 0
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4

terceiro:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t4, terceiro
	addi $t0, $t0, 1
	move $t1, $t0
	addi $t1, $t1, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t0
	bgt $t5, 1, terceiro
	jal impressao
	li $t1, 0
	li $t0, 1
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
quarto:	
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t0, $t0, 1
	blt $t0, $t4, quarto
	addi $t1, $t1, 1
	move $t0, $t1
	addi $t0, $t0, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t1
	bgt $t5, 1, quarto
	jal impressao
	li $t1, 0
	li $t0, 1
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
quinto:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t0, $t0, 1
	blt $t0, $t4, quinto
	addi $t1, $t1, 1
	move $t0, $t1
	addi $t0, $t0, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t1
	bgt $t5, 1, quinto
	li $t0, 1
	subi $t1, $a1, 1
	li $t4, 0
	
quinto2:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t0, $t0, 1
	blt $t0, $t1, quinto2
	subi $t1, $t1, 1
	move $t0, $t1
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	sub $t5, $t1, $t4
	bgt $t5, 1, quinto2
	jal impressao
	li $t1, 1
	li $t0, 0
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
sexto:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t4, sexto
	addi $t0, $t0, 1
	move $t1, $t0
	addi $t1, $t1, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t0
	bgt $t5, 1, sexto
	li $t1, 1
	subi $t0, $a1, 1
	li $t4, 0
	
sexto2:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t0, sexto2
	addi $t4, $t4, 1
	move $t1, $t4
	addi $t1, $t1, 1
	subi $t0, $t0, 1
	sub $t5, $t0, $t4
	bgt $t5, 1, sexto2
	jal impressao
	li $t1, 1
	li $t0, 0
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
setimo:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t4, setimo
	addi $t0, $t0, 1
	move $t1, $t0
	addi $t1, $t1, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t0
	bgt $t5, 1, setimo
	li $t1, 0
	li $t0, 1
	subi $t4, $a1, 1

setimo2:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t0, $t0, 1
	blt $t0, $t4, setimo2
	addi $t1, $t1, 1
	move $t0, $t1
	addi $t0, $t0, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t1
	bgt $t5, 1, setimo2
	jal impressao
	li $t1, 0
	li $t0, 1
	subi $t4, $a1, 1
	sub.s $f4, $f4, $f4
	
oitavo:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t0, $t0, 1
	blt $t0, $t4, oitavo
	addi $t1, $t1, 1
	move $t0, $t1
	addi $t0, $t0, 1
	subi $t4, $t4, 1
	sub $t5, $t4, $t1
	bgt $t5, 1, oitavo
	li $t1, 1
	subi $t0, $a1, 1
	li $t4, 0
	
oitavo2:
	jal matIndex
	l.s $f2, ($v0)
	add.s $f4, $f4, $f2
	addi $t1, $t1, 1
	blt $t1, $t0, oitavo2
	addi $t4, $t4, 1
	move $t1, $t4
	addi $t1, $t1, 1
	subi $t0, $t0, 1
	sub $t5, $t0, $t4
	bgt $t5, 1, oitavo2
	jal impressao
	li $v0, 10
	syscall

impressao:
	mov.s $f12, $f4
	li $v0, 2
	syscall
	la $a0, 10
	li $v0, 11
	syscall
	jr $ra
	
matIndex:
	mul $v0, $t0, $a2
	add $v0, $v0, $t1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
	jr $ra
