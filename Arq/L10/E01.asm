.data
Erro:	.asciiz "Não foi possível abrir o arquivo"
File:	.asciiz "C:\\Eric\\Facul\\2º ano\\Arq\\L10\\dados1.txt"	#Caminho absoluto do arquivo"
Buffer:	.asciiz "."
OutA:	.asciiz "O maior valor é: "
OutB:	.asciiz "\nO menor valor é: "
OutC:	.asciiz "\nA quantidade de ímpares é: "
OutD:	.asciiz "\nA quantidade de pares é: "
OutE:	.asciiz "\nA soma dos valores é: "
OutF:	.asciiz "\nEm ordem crescente:\n"
OutG:	.asciiz "\nEm ordem decrescente:\n"
OutH:	.asciiz "\nO produto: "
OutI:	.asciiz "\nO número de caracteres: "

#$s7 = total de caracteres no arquivo 
#$s6 = file descriptor
#$s5 = endereço base do vetor de números
#$s3 = quantidade de números no vetor
#$s4 = soma dos números

######################################################################
#				NOTAS                                #
#1. O caminho do arquivo deve ser absoluto,                          #
#    ou o arquivo deve estar na pasta onde o mars.jar será executado #
#2. Supõe-se que no arquivo haja apenas números e espaços,           #
#    e apenas um espaço entre cada número                            #
#3. Supõe-se que todos os números no arquivo são naturais            #
######################################################################

.text
main:
	jal fopen
	move $s6, $v0
	move $a0, $s6
	la $a1, Buffer
	li $a2, 1
	jal leitura
	move $a0, $s6
	jal fclose
	jal saidas
	j fim

saidas:		#resolve todas as questões do exercício
	move $a0, $ra
	jal fStart
	move $s0, $s5	#endereço do vetor para o bubbleSort
	move $s1, $s3	#tamanho do vetor para o bubbleSort
	jal bubbleSort
	move $t0, $s5
	move $s3, $s1
saidasExtremos:	#encontra o maior e menor número do vetor
	lw $t1, ($t0)	#$t1 = menor número do vetor
	subi $t2, $s3, 1	#$t2 = tamVet-1
	sll $t2, $t2, 2
	add $t0, $t0, $t2
	lw $t2, ($t0)	#$t2 = maior número do vetor
	la $a0, OutA
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, OutB
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
saidasImparPar:	#Conta quantos pares e quantos ímpares tem no vetor, além de fazer a soma dos números
	move $t0, $s5
	li $t1, 0	#contador do vetor
	li $t2, 0	#contador de pares
	li $t3, 0	#contador de ímpares
	li $s4, 0	#somador
	li $s2, 1	#guarda a multiplicação dos elementos
	saidaImparParLoop:
		lw $t4, ($t0)
		add $s4, $s4, $t4	#soma = soma + vet[i]
		mul $s2, $s2, $t4	#mult = mult * vet[i]
		li $t9, 2
		div $t4, $t9
		mfhi $t4
		bnez $t4, saidaImparParLoopIMPAR	#if ((vet[i]/2)%2 != 0) then addImpar
		addi $t2, $t2, 1	#contPar++
		j saidaImparParLoopContinua
		saidaImparParLoopIMPAR:
			addi $t3, $t3, 1	#contImpar++
	saidaImparParLoopContinua:
		addi $t1, $t1, 1	#adiciona no contador
		addi $t0, $t0, 4
		blt $t1, $s3, saidaImparParLoop
	la $a0, OutC
	li $v0, 4
	syscall
	move $a0, $t3
	li $v0, 1
	syscall
	la $a0, OutD
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, OutE
	li $v0, 4
	syscall
	move $a0, $s4
	li $v0, 1
	syscall
saidaOrdenada:
	la $a0, OutF
	li $v0, 4
	syscall
	move $t0, $s5
	li $t1, 0	#contador
	saidaOrdenadaLoop:
		lw $a0, ($t0)
		li $v0, 1
		syscall
		li $a0, 32	#código ascii pra espaço
		li $v0, 11
		syscall
		addi $t1, $t1, 1
		addi $t0, $t0, 4
		blt $t1, $s3, saidaOrdenadaLoop
saidaOrdemInversa:	#A lógica é identifa à função anterior, porém como $t0 já está na última posição
			#	do vetor, só precisamos diminui-lo até chegar na primeira posição
	la $a0, OutG
	li $v0, 4
	syscall
	li $t1, 0
	saidaOrdemInversaLoop:
		subi $t0, $t0, 4
		lw $a0, ($t0)
		li $v0, 1
		syscall
		li $a0, 32
		li $v0, 11
		syscall
		addi $t1, $t1, 1
		blt $t1, $s3, saidaOrdemInversaLoop
saidaProdutosEQtdCaracter:
	la $a0, OutH
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	la $a0, OutI
	li $v0, 4
	syscall
	move $a0, $s7
	li $v0, 1
	syscall
	j return

leitura:	#lê os números do arquivo, e os armazena temporariamente na stack, depois os armazena em um vetor
	move $t0, $a0
	move $a0, $ra
	jal fStart
	move $a0, $t0
	li $t0, 0
leituraLoop:
	li $v0, 14
	syscall
	blez $v0, leituraFim
	addi $s7, $s7, 1
	lb $t0, Buffer
	li $t1, 32
	beq $t0, $t1, leituraNovoNum	#Por questões de simplicidade, assumirei que no arquivo há somente números e espaços
	subi $t0, $t0, 48
	mul $t2, $t2, 10	#$t2 = numero sendo lido
	add $t2, $t2, $t0
	j leituraLoop
leituraNovoNum:
	subi $sp, $sp, 4
	sw $t2, ($sp)
	li $t2, 0
	addi $t3, $t3, 1	#$t3 = contador da quantidade de números na stack
	bnez $t9, leituraFim
	j leituraLoop
leituraFim:	#coloca todos os números da stack em um vetor
	li $t9, 1
	bnez $t2, leituraNovoNum
	mul $a0, $t3, 4
	jal malloc
	move $s5, $v0
	move $t0, $s5
	move $s3, $t3
leituraFimLoop:
	lw $t1, ($sp)
	sw $t1, ($t0)
	addi $t0, $t0, 4
	addi $sp, $sp, 4
	subi $t3, $t3, 1
	bnez $t3, leituraFimLoop
	j return
	
fclose:	#fecha o arquivo
	li $v0, 16
	syscall
	jr $ra

fopen:	#Tenta abrir o arquivo, encerra o programa caso não consiga
	move $a0, $ra
	jal fStart
	la $a0, File
	li $a1, 0
	li $v0, 13
	syscall
	bgez $v0, return	#Retorna para o programa, caso consiga abrir o arquivo
	la $a0, Erro
	li $v0, 4
	syscall			#Imprime mensagem de erro caso contrário
	j fim
	
bubbleSort:
	move $a0, $ra
	jal fStart
	li $s2, 0	#contador da posição atual
	li $s3, 0	#"bool" para verificar se alguma troca foi feita
bubbleSortLoop:
	move $t0, $s2
	sll $t0, $t0, 2
	add $t0, $t0, $s0
	addi $t1, $t0, 4
	lw $t2, ($t0)
	lw $t3, ($t1)
	blt $t3, $t2, bubbleSortIsLesser
bubbleSortLoop2:
	addi $s2, $s2, 1
	blt $s2, $s1, bubbleSortLoop
	beq $s3, $zero, return
	li $s2, 0
	li $s3, 0
	j bubbleSortLoop
bubbleSortIsLesser:
	addi $s2, $s2, 1
	beq $s2, $s1, bubbleSortLoop2
	li $s3, 1
	sw $t2, ($t1)
	sw $t3, ($t0)
	j bubbleSortLoop
	
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
fim:
	li $v0, 10
	syscall
