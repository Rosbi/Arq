.data
File:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10b\\E01-gemeos.txt"	#Caminho absoluto do arquivo"
Out1:	.asciiz "Insira o tamanho máximo do intervalo: "
OutNL:	.asciiz "\r\n"
	.align 2
Buffer:	.space 20

###                             ###
#              NOTA               #
# Esse programa utiliza a fórmula #
# proposta por Paul Stäckel, onde #
#  um par de gêmeos é dado por    #
# 	      6*k+-1              #
###                             ###

.text
main:
	jal fopen
	move $s1, $v0	# Armazena o file descriptor em $s1
	la $a0, Out1	#
	li $v0, 4	#
	syscall		# Lê o tamanho máximo do intervalo ([1,n])
	li $v0, 5	#
	syscall		#
	move $s0, $v0	# Armazena 'n' em $s0
	jal gemeos
	j fim
	
gemeos:
	li $t9, 0	#contador do intervalo (k)
	move $a0, $ra
	jal fStart
	li $a0, 5		#
	blt $s0, $a0, return	#Verifica se n<7, pois (5,7) são os menores gemeos possiveis
gemeosLoop:
	move $t8, $a0	#$a0 = 6*k+1
	jal primo			##
	beqz $v0, gemeosLoopNext	#
	subi $a0, $a0, 2		# Verifica se 6*k+1 e 6*k-1 são primos,
	jal primo			# caso não, vai para a próxima iteração
	beqz $v0, gemeosLoopNext	#
	addi $a0, $a0, 2		##
gemeosLoopWrite:
	la $a1, Buffer	##
	jal itoa	#
	move $a2, $v0	# aplica a função itoa em $a0,
	la $a1, Buffer	# e escreve com fwrite
	move $a0, $s1	#
	jal fwrite	##
	li $t0, 44	##
	sw $t0, Buffer	#
	move $a0, $s1	# Imprime ',' no arquivo
	la $a1, Buffer	#
	li $a2, 1	#
	li $v0, 15	#
	syscall		##
	subi $a0, $t8, 2	##
	la $a1, Buffer		#
	jal itoa		#
	move $a0, $s1		# aplica itoa em $a0 - 1, 
	la $a1, Buffer		# e escreve com fwrite
	move $a2, $v0		#
	jal fwrite		##
	move $a0, $s1	##
	la $a1, OutNL	#
	li $a2, 2	# Imprime uma nova linha no arquivo
	li $v0, 15	#
	syscall		##
gemeosLoopNext:
	addi $t9, $t9, 1	# k++
	mul $a0, $t9, 6		## $a0 = k+1
	addi $a0, $a0, 1	##
	ble $a0, $s0, gemeosLoop	#if ($a0 > n) return
	j return

primo:	move $t0, $a0
	move $t1, $t0
	li $t2, 1
primo1:	subi $t1, $t1, 1
	ble $t1, $t2, true
	div $t0, $t1
	mfhi $t3
	beqz $t3, false
	j primo1
false:	li $v0, 0
	jr $ra
true:	li $v0, 1
	jr $ra

itoa:	#$a0 = numero inteiro, $a1 = buffer de saida, retorna em $v0 o numero de caracteres
	li $v0, 0
	li $t0, 0
	li $t1, 0
itoaLoop:	#código 'intstring' providenciado na lista
	div $a0, $a0, 10
	mfhi $t0
	subi $sp, $sp, 4
	sw $t0, ($sp)
	addi $v0, $v0, 1
	bnez $a0, itoaLoop
itoaLoop2:
	lw $t0, ($sp)
	addi $sp, $sp, 4
	add $t0, $t0, 48
	sb $t0, ($a1)
	addi $a1, $a1, 1
	addi $t1, $t1, 1
	bne $t1, $v0, itoaLoop2
	sb $zero, ($a1)
	jr $ra

fwrite:	#$a0 = file descriptor, $a1 = buffer de saida, $a2 = quantidade de caracteres a ser escrita
	li $v0, 15
	syscall
	jr $ra

fStart:
	subi $sp, $sp, 4
	sw $a0, ($sp)
	jr $ra
return:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
fim:	#encerra o programa
	li $v0, 10
	syscall
fopen:	#abre o arquivo File em modo de escrita
	la $a0, File
	li $a1, 1
	li $v0, 13
	syscall
	jr $ra
