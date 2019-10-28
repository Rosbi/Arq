.data
Out1:	.asciiz "Qual o tamanho do vetor?\n"
Out2:	.asciiz "\nInsira os elementos do vetor:\n"
Out3:	.asciiz "\nO segmento é: "
Out4:	.asciiz "\nA soma do segmento é: "
Flt0:	.float 0.0
Flt1:	.float 1.0

#$s0 = endereço base do vetor
#$s1 = tamanho do vetor

.text
main:
	jal leTamanho
	move $s1, $v0
	move $a0, $v0
	jal malloc
	move $s0, $v0
	move $a0, $v0
	move $a1, $s1
	jal leVetor
	jal segmentoNotaMaxima
	mov.s $f12, $f0
	mov.s $f14, $f2
	move $a0, $s0
	move $a1, $s1
	jal imprimeSegmento
	j fim
	
imprimeSegmento:
	cvt.w.s $f4, $f12
	mfc1 $t1, $f4	#inicio do segmento
	cvt.w.s $f6, $f14
	mfc1 $t2, $f6	#fim do segmento
	l.s $f8, Flt0	#soma do segmento
	move $t0, $a0
	move $a0, $ra
	jal fStart
	la $a0, Out3
	li $v0, 4
	syscall
imprimeSegmentoL:
	li $a0, 10
	li $v0, 11
	syscall
	move $a0, $t0
	move $a1, $t1
	jal vetIndex
	l.s $f12, ($v0)
	add.s $f8, $f8, $f12
	li $v0, 2
	syscall
	addi $t1, $t1, 1
	ble $t1, $t2, imprimeSegmentoL
	la $a0, Out4
	li $v0, 4
	syscall
	mov.s $f12, $f8
	li $v0, 2
	syscall
	j return
	
segmentoNotaMaxima:	#$a0 = endereço vetor, $a1 = tamanho vetor
	l.s $f4, Flt0	#soma
	l.s $f6, Flt0	#pivo
	l.s $f8, Flt0	#somMax
	l.s $f16, Flt0	#def1
	l.s $f18, Flt0	#def2
	move $t0, $a0	
	move $t1, $a1
	move $a0, $ra
	jal fStart
	li $t2, 0	#contador
segmentoNotaMaximaL:
	move $a0, $t0
	move $a1, $t2
	jal vetIndex
	l.s $f0, ($v0)
	add.s $f4, $f4, $f0
	l.s $f20, Flt0
	c.lt.s $f4, $f20
	bc1t segmentoNotaMaximaLIf1
	c.lt.s $f8, $f4
	bc1t segmentoNotaMaximaLIf2
segmentoNotaMaximaLContinua:
	addi $t2, $t2, 1
	ble $t2, $t1, segmentoNotaMaximaL
	mov.s $f0, $f16
	mov.s $f2, $f18
	j return
segmentoNotaMaximaLIf1:
	l.s $f4, Flt0
	l.s $f20, Flt1
	mtc1 $t2, $f22
	cvt.s.w $f22, $f22
	add.s $f6, $f22, $f20
	j segmentoNotaMaximaLContinua
segmentoNotaMaximaLIf2:
	mov.s $f8, $f4
	mov.s $f16, $f6
	mtc1 $t2, $f20
	cvt.s.w $f20, $f20
	mov.s $f18, $f20
	j segmentoNotaMaximaLContinua
	
leVetor:	#$a0 = endereçoVet, $a1 = tamVet
	li $t9, 0
	move $t8, $a1
	move $t7, $a0
	move $a0, $ra
	jal fStart
leVetorL:
	li $v0, 6
	syscall
	move $a0, $t7
	move $a1, $t9
	jal vetIndex
	s.s $f0, ($v0)
	addi $t9, $t9, 1
	blt $t9, $t8, leVetorL
	j return
	
leTamanho:
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	jr $ra

malloc:	#aloca a quantidade de bytes em $a0
	li $v0, 9
	syscall
	jr $ra
fStart:	#guarda o $ra (se encontra em $a0) na stack
	subi $sp, $sp, 4
	sw $a0, ($sp)
	jr $ra
return:	#carrega o $ra e pula para ele
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
vetIndex:	#retorna o endereço i do vetor
		#$a0 = endereço Vetor, $a1 = indice do vetor
	sll $v0, $a1, 2
	add $v0, $v0, $a0
	jr $ra
fim:
	li $v0, 10
	syscall