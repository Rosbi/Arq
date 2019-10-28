.data
Out1:	.asciiz "Insira o x (radiandos): "
Out2:	.asciiz "Insira o n (inteiro): "
Out3:	.asciiz "O cos(x) é aproximadamente: "
Doubn1:	.double -1.0
Doub0:	.double 0.0
Doub1:	.double 1.0
Doub2:	.double 2.0
a:	.double 7.0
aa:	.double 5.0
.text
main:
	andi $sp, $sp, 0xfffffff8	#alinha a stack para 8 bytes
	jal leNumeros
	jal calculaCos
	jal imprimeCos
	j end
	
imprimeCos:
	la $a0, Out3
	li $v0, 4
	syscall
	mov.d $f12, $f24
	li $v0, 3
	syscall
	jr $ra
	
calculaCos:
	move $a0, $ra
	jal fStart
	l.d $f24, Doub0		#$f24 = cos(x)
calculaCosLoop:
	mov.d $f12, $f20
	l.d $f4, Doub2
	mul.d $f14, $f22, $f4
	jal potencia
	mov.d $f6, $f0
	l.d $f4, Doub2
	mul.d $f12, $f22, $f4
	jal fatorial
	mov.d $f8, $f0
	div.d $f6, $f6, $f8
	l.d $f12, Doubn1
	mov.d $f14, $f22
	jal potencia
	mul.d $f4, $f0, $f6
	add.d $f24, $f24, $f4
	l.d $f4, Doub1
	sub.d $f22, $f22, $f4
	l.d $f4, Doub0
	c.lt.d $f22, $f4
	bc1f calculaCosLoop
	j return
	
fatorial:	#f12!
	move $a0, $ra
	jal fStart
	subi $sp, $sp, 8
	s.d $f12, ($sp)
	l.d $f4, Doub1
	c.le.d $f12, $f4
	bc1t returnDouble1Fact
	l.d $f4, Doub1
	sub.d $f12, $f12, $f4
	jal fatorial
	l.d $f4, ($sp)
	mul.d $f0, $f0, $f4
	addi $sp, $sp, 8
	j return	
potencia:	#f12^f14, f14 deve ser um inteiro
	move $a0, $ra
	jal fStart
	l.d $f4, Doub0
	c.le.d $f14, $f4
	bc1t returnDouble1
	l.d $f4, Doub1
	sub.d $f14, $f14, $f4
	jal potencia
	mul.d $f0, $f0, $f12
	j return
returnDouble1Fact:
	addi $sp, $sp, 8
returnDouble1:
	l.d $f0, Doub1
	j return
	
leNumeros:
	move $a0, $ra
	jal fStart
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 7
	syscall
	mov.d $f20, $f0
	la $a0, Out2
	li $v0, 4
	syscall
	li $v0, 7
	syscall
	mov.d $f22, $f0
	j return 
	
malloc:
	li $v0, 9
	syscall
	jr $ra
fStart:
	subi $sp, $sp, 8
	sw $a0, ($sp)
	jr $ra
return:
	lw $ra, ($sp)
	addi $sp, $sp, 8
	jr $ra
end:
	li $v0, 10
	syscall
