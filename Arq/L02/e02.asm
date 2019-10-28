.data
Input: .asciiz "Insira um numero: "
Output: .asciiz "Maior numero: "

.text
main: 	jal ler
	move $s0, $v0
	jal ler
	move $s1, $v0
	move $a0, $s0
	move $a1, $s1
	jal maior
	move $a0, $v0
	jal print
	j sair
	
ler:	la $a0, Input	#Carrega em a0 o endere�o da string
	li $v0, 4	#Carrega em v0 o c�digo de impress�o de string, e a imprime
	syscall
	li $v0, 5	#Carrega o c�digo de leitura de inteiro, e l� o input do usu�rio
	syscall
	jr $ra		#retorna pra main
	
maior:	bgt $a0, $a1, retA	#Se a > b, retorna a
	move $v0, $a1		#sen�o retorna a e volta para a main
	jr $ra

retA:	move $v0, $a0	#retorna a e volta para a main
	jr $ra
	
print:	move $t0, $a0	#carrega em t0 o maior numero
	la $a0, Output	#carrega o endere�o da string
	li $v0, 4	#carrega o valor de impress�o de string
	syscall		#imprime string
	move $a0, $t0	#devolve o maior numero para a0
	li $v0, 1	#carrega o valor de impress�o de inteiro
	syscall		#imprime inteiro
	jr $ra		#volta para a main
	
sair:	li $v0, 10	#carrega o valor de fim de programa
	syscall		#encerra o programa