.data
Input:   .asciiz "Insira um numero: "
maiOut:  .asciiz "\nMaior numero: "
menOut:  .asciiz "\nMenor numero: "
impOut:  .asciiz "\nQuantidade de impares: "
mai:     .word 0
men:     .word 0
imp:     .word 0

.text
main: 	jal ler		#chama a função 'ler'
	move $s0, $v0	#coloca em s0 e v0 o retorno de 'ler'
	move $a0, $v0	
	jal impar	#passa o número lido para a função 'impar'
	jal ler		
	move $s1, $v0	#coloca em s1 e a0 o retorno da segunda leitura
	move $a0, $v0
	jal impar	
	move $a0, $s0	#coloca s0 e s1 como os parametros da funcao
	move $a1, $s1
	jal maior	#chama a funcao 'maior'
	sw $v0, mai	#escreve o maior dos dois primeiros numeros na variavel 'mai'
	jal menor	#faz o mesmo para o menor numero
	sw $v0, men
	
	jal ler		#le um numero e o armazena em a0
	move $a0, $v0	
	jal impar	#atualiza o contador de impares, se necessario
	lw $a1, mai	#carrega em a1 o maior numero ate agora
	jal maior	#verifica qual o maior, e o armazena em 'mai'
	sw $v0, mai
	lw $a1, men	#mesmo processo, mas para o menor valor
	jal menor
	sw $v0, men
	
	jal ler		#o bloco anterior é repetido, até o 10º numero
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal ler
	move $a0, $v0
	jal impar
	lw $a1, mai
	jal maior
	sw $v0, mai
	lw $a1, men
	jal menor
	sw $v0, men
	
	jal print	#vai para função de print
	
	j sair		#prossegue para encerrar o programa
	
ler:	la $a0, Input	#Carrega em a0 o endereço da string
	li $v0, 4	#Carrega em v0 o código de impressão de string, e a imprime
	syscall
	li $v0, 5	#Carrega o código de leitura de inteiro, e lê o input do usuário
	syscall
	jr $ra		#retorna pra main
	
maior:	bgt $a0, $a1, retA	#Se a > b, retorna a
	move $v0, $a1		#senão retorna a e volta para a main
	jr $ra
menor:	blt $a0, $a1, retA
	move $v0, $a1
	jr $ra
retA:	move $v0, $a0	#retorna a e volta para a main
	jr $ra
	
impar:	li $t0, 2		#carrega 2 para t0
	divu $a0, $t0		#divide a/2
	mfhi $t0		#move para t0 o resto da divisão
	bnez $t0, impAdd	#se resto != 0, aumenta o contador de impares
	jr $ra			#se não, retorna para a main
impAdd:	lw $t0 imp		#carrega em t0 a quantidade de impares
	addi $t0, $t0, 1	#aumenta em 1 a quantidade
	sw $t0, imp		#armazena a nova quantidade na variavel
	jr $ra			#retorna para a main
	
print:	lw $t0, mai		#carrega o maior valor em t0
	la $a0, maiOut		#carrega a string para a0
	li $v0, 4		#carrega o código de impressão de string
	syscall			#imprime a string
	move $a0, $t0		#coloca o maior em a0
	li $v0, 1		#carrega o código de impressão de inteiro
	syscall			#imprime o maior
	
	lw $t0, men		#repete o processo para o menos
	la $a0, menOut
	li $v0, 4	
	syscall		
	move $a0, $t0	
	li $v0, 1	
	syscall	
	
	lw $t0, imp		#repete o processo para a quantidade de impares
	la $a0, impOut
	li $v0, 4	
	syscall		
	move $a0, $t0	
	li $v0, 1	
	syscall			
	jr $ra		
	
sair:	li $v0, 10		#carrega o código de fim de programa
	syscall			#encerra o programa
