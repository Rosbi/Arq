.data
FileIn:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10b\\E02-in.txt"	#Caminho absoluto do arquivo"
FileOut:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10b\\E02-out.txt"
Erro:	.asciiz "Não foi possível abrir o arquivo"
Buffer:	.asciiz "."

#$s0 = file descriptor FileIn
#$s1 = file descriptor FileOut

.text
main:
	la $a0, FileIn
	li $a1,  0
	jal fopen
	move $s0, $v0
	la $a0, FileOut
	li $a1, 1
	jal fopen
	move $s1, $v0
	jal copia
	j fim
	
copia:
	move $a0, $ra
	jal fStart
copiaLoop:
	move $a0, $s0	##
	la $a1, Buffer	# lê cada caracter do arquivo
	li $a2, 1	#
	jal fread	##
	beqz $v0, return	# caso caracter = EOF, retorna
	lw $a0, Buffer	  #
	jal verificaVogal #verifica se o caracter dado é uma vogal
	beqz $v0, copiaLoopNormal	#Caso não seja, pula as próximas duas linhas
	li $t0, 42	# Troca o caracter do buffer por um asterisco, caso seja uma vogal
	sw $t0, Buffer	#
copiaLoopNormal:
	move $a0, $s1	##
	la $a1, Buffer	# Escreve o caracter no arquivo
	jal fwrite	#
	j copiaLoop	##
	
verificaVogal:	#$a0 é o caracter a ser verificado
	li $t0, 65			#
	beq $a0, $t0, verificaVogalTrue	# Faz a verificação para todas as vogais
	li $t0, 69			# (maiúsculas e minúsculas)
	beq $a0, $t0, verificaVogalTrue	#
	li $t0, 73			
	beq $a0, $t0, verificaVogalTrue	#
	li $t0, 79			# NOTA:
	beq $a0, $t0, verificaVogalTrue	# Não funciona para caracteres acentuados
	li $t0, 85			# (como 'ê', 'é', 'ã', 'ó', etc.)
	beq $a0, $t0, verificaVogalTrue	#
	li $t0, 97
	beq $a0, $t0, verificaVogalTrue
	li $t0, 101
	beq $a0, $t0, verificaVogalTrue
	li $t0, 105
	beq $a0, $t0, verificaVogalTrue
	li $t0, 111
	beq $a0, $t0, verificaVogalTrue
	li $t0, 117
	beq $a0, $t0, verificaVogalTrue
verificaVogalFalse:	#retorna 0 caso não tenha passado por nenhum dos casos
	li $v0, 0
	jr $ra
verificaVogalTrue:	#retorna 1 caso algum if tenha passado
	li $v0, 1
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