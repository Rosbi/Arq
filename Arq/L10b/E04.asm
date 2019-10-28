.data
FileIn:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10b\\E04-mat.txt"	#Caminho absoluto do arquivo"
Erro:	.asciiz "Não foi possível abrir o arquivo"
Buffer:	.asciiz "."
BufferNL:	.asciiz "\r\n"

.text
main:
	la $a0, FileIn	##
	li $a1, 0	# Abre o arquivo em modo leitura
	jal fopen	##
	move $s0, $v0
	jal leArquivo
	jal preencheMatriz
	jal anulaMat
	jal printMat
	j fim

anulaMat:
	li $t0, 0
	move $t9, $ra
anulaMatLoop:
	bge $t0, $s3, anulaMatReturn
	addi $t0, $t0, 1
	lw $a0, ($sp)
	addi $sp, $sp, 4
	lw $a1, ($sp)
	addi $sp, $sp, 4
	move $a2, $s2
	move $a3, $s4
	jal matIndex
	li $t3, 0
	sw $t3, ($v0)
	j anulaMatLoop
anulaMatReturn:
	jr $t9

printMat:
	li $t0, 0	#contador de linhas
	li $t1, 0	#contador de colunas
	move $a0, $ra
	jal fStart
printMatLoop:
	move $a0, $t1
	move $a1, $t0
	move $a2, $s2
	move $a3, $s4
	jal matIndex
	lw $a0, ($v0)
	li $v0, 1
	syscall
	
	li $a0, 32	##
	li $v0, 11	# Imprime um espaço entre os números
	syscall		##
	
	addi $t1, $t1, 1
	blt $t1, $s2, printMatLoop
	li $t1, 0
	addi $t0, $t0, 1
	
	li $a0, 10	##
	li $v0, 11	# Imprime uma nova linha
	syscall		##
	
	blt $t0, $s1, printMatLoop
	j return

preencheMatriz:
	li $t0, 0	#contador de linhas
	li $t1, 0	#contador de colunas
	move $a0, $ra
	jal fStart
preencheMatrizLoop:
	move $a0, $t0
	move $a1, $t1
	move $a2, $s2
	move $a3, $s4
	jal matIndex
	li $t2, 1
	sw $t2, ($v0)
	addi $t1, $t1, 1
	blt $t1, $s2, preencheMatrizLoop
	li $t1, 0
	addi $t0, $t0, 1
	blt $t0, $s1, preencheMatrizLoop
	j return
			
leArquivo:	#retorna em $s4 o ponteiro para a matriz, $s1=linhas, $s2=colunas, $s3=quantidadeNulos
	move $a0, $ra
	jal fStart
	move $a0, $s0	##
	jal leNumero	#
	move $s1, $v0	# Lê a quantidade de linhas,
	jal leNumero	# colunas e nulos da matriz 
	move $s2, $v0	#
	jal leNumero	#
	move $s3, $v0	##
	
#	la $a1, BufferNL	##
#	li $a2, 2		# Passa a posição do arquivo para a próxima linha
#	jal fread		##
	li $t9, 0
leArquivoLoop:
	bge $t9, $s3, leArquivoLoopFim
	addi $t9, $t9, 1
	jal leNumero		##
	subi $sp, $sp, 4	#
	sw $v0, ($sp)		# Lê o par ordenado presente
	jal leNumero		# na linha atual
	subi $sp, $sp, 4	#
	sw $v0, ($sp)		##
	
#	la $a1, BufferNL	##
#	li $a2, 2		# Passa a posição do arquivo para a próxima linha
#	jal fread		##
	j leArquivoLoop
leArquivoLoopFim:
	mul $a0, $s1, $s2
	jal malloc		#Aloca memória para a matriz
	move $s4, $v0
	mul $t0, $t9, 8		##
	add $t0, $t0, $sp	# Vai para onde $ra está armazenado
	lw $ra, ($t0)		##
	jr $ra
	
leNumero:	#$a0=file descriptor
	move $t0, $a0
	move $a0, $ra
	jal fStart
	move $a0, $t0
	li $t0, 0
leNumeroLoop:
	la $a1, Buffer	##
	li $a2, 1	# Lê um caracter do arquivo
	jal fread	##
	beqz $v0, leNumeroReturn
	subi $sp, $sp, 8
	sw $a0, ($sp)	#Armazena o file descriptor na stack
	sw $t0, 4($sp)
	lb $a0, Buffer
	jal verificaNum
	lw $a0, ($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	bltz $v0, leNumeroReturn
	mul $t0, $t0, 10
	add $t0, $t0, $v0
	j leNumeroLoop
leNumeroReturn:
	move $v0, $t0
	j return
	
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

malloc:
	li $v0, 9
	syscall
	jr $ra
matIndex:	#retorna o elemento no indice [i][j] de Mat ()
		#$a0 = linhaAtual, $a1 = colunaAtual, $a2 = nCol, $a3 = endereçoMat
	mul $v0, $a0, $a2
	add $v0, $v0, $a1
	sll $v0, $v0, 2
	add $v0, $v0, $a3
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