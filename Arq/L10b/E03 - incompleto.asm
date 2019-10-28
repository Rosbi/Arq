.data
File:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10b\\E03-vet.txt"	#Caminho absoluto do arquivo"
Erro:	.asciiz "Não foi possível abrir o arquivo"
Out1:	.asciiz "Insira a posição a ser lida: "
OutE:	.asciiz "Posição inválida"
Buffer:	.asciiz "."

#$s0 = file descriptor (leitura)
#$s1 = file descriptor (escrita)
#$s2 = posição do vetor a ser lida

.text
main:
	la $a0, File	##
	li $a1, 0	# Abre o arquivo em modo de leitura,
	jal fopen	# e guarda o file descriptor em $s0
	move $s0, $v0	##
	
	jal lePosicaoUser
	move $s2, $v0
	jal lePosicaoVet
	move $a0, $s0
	jal fclose
	
	la $a0, File	##
	li $a1, 1	# Abre o arquivo em modo de escrita,
	li $a2, 0	#
	jal fopen	# e guarda o file descriptor em $s1
	move $s1, $v0	##
	
	jal escrevePosVet
	j fim
	
escrevePosVet:
	li $t0, 0
escrevePosVetLoop1:
	move $a0, $s1
	la $a1, Buffer
	li $a2, 1
	jal fread
	addi $t0, $t0, 1
	blt $t0, $v1, escrevePosVetLoop1
	li $t0, 42
	sb $t0, Buffer
	move $a0, $s1
	la $a1, Buffer
	li $a2, 1
	jal fwrite
	j fim

lePosicaoVet:
	move $a0, $ra
	jal fStart
	li $t0, 0	#contador de posições até n
	li $t1, 0	#numero sendo lido
	li $t2, 0	#contador de caracteres até a posição n
lePosicaoVetLoop:
	beq $t0, $s2, lePosicaoVetLoopContinua
	addi $t2, $t2, 1	#Caso tenha chegado na posição n, para o contador
lePosicaoVetLoopContinua:
	move $a0, $s0	##
	la $a1, Buffer	# Lê um caracter do arquivo
	li $a2, 1	#
	jal fread	##
	subi $sp, $sp, 4	##
	sw $t0, ($sp)		# Armazena o contador na stack
	lb $a0, Buffer		#
	jal verificaNum		# Verifica se o caracter lido é um número
	lw $t0, ($sp)		# Carrega o contador de volta da stack
	addi $sp, $sp, 4	##
	bltz $v0, lePosicaoVetLoopNovoNum
	mul $t1, $t1, 10	# Coloca $t1 uma casa pra esquerda
	add $t1, $t1, $v0	# Adiciona $v0 à $t1
	j lePosicaoVetLoop
lePosicaoVetLoopNovoNum:
	beq $t0, $s2, lePosicaoTrue	#Caso tenha chegado em n, retorna os valores
	addi $v0, $v0, 48	#Aumenta $v0 em 48, que foi decrementado por verificaNum
	beqz $v0, lePosicaoErro	#Caso chegue ao fim do arquivo, indica um erro
	li $t1, 0		#Zera o número sendo lido
	addi $t0, $t0, 1
	j lePosicaoVetLoop
lePosicaoTrue:	#Retorna o número em $v0, e a quantidade de caracteres em $v1
	move $v0, $t1
	move $v1, $t2
	j return
lePosicaoErro:
	la $a0, OutE
	li $v0, 4
	syscall
	j fim
		
verificaNum:	#verifica se o caracter em $a0 é um número
	subi $a0, $a0, 48		#
	bltz $a0, verificaNumFalse	# Verifica se o código ascii do caracter
	li $t0, 9			#  está entre 48 e 57 (intervalo de números)
	bgt $a0, $t0, verificaNumFalse	#
verificaNumTrue:	#Caso seja um número, retorna o próprio número
	move $v0, $a0
	jr $ra
verificaNumFalse:	#Retorna -1 caso não seja um número
	li $v0, -1
	jr $ra
	
lePosicaoUser:	#Lê o input do usuário para a posição do vetor
	la $a0, Out1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	jr $ra
	
fclose:	#Fecha o arquivo em $a0
	li $v0, 16
	syscall
	jr $ra
fopen:	#$a0 = arquivo a ser aberto, $a1 = modo de abertra
	li $v0, 13
	syscall
	bltz $v0, fopenErro
	jr $ra
fopenErro:
	la $a0, Erro
	li $v0, 4
	syscall
	j fim
fread:	#$a0 = file descriptor, $a1, buffer de entrada, $a2 = qtd de caracteres a ser lida
	li $v0, 14
	syscall
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