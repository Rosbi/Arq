.data
out:	.asciiz "Insira a string: "
outFim:	.asciiz "Nova string: "
in:	.space 50

.text
main:	la $a0, out	
	li $v0, 4
	syscall		#imprime a mensagem pra inser��o de string
	la $a0, in
	li $a1, 50
	li $v0, 8
	syscall		#l� string de 50 caracteres
loop:	lb $t0, ($a0)		#t0 = in[k]
	beqz $t0, fim		
	beq $t0, 10, fim	#condi��es para sair do loop
	blt $t0, 97, continua
	bgt $t0, 122, continua	#se o valor do caracter n�o estiver entre 97 e 122 (a at� z), pula a etapa de alter�-lo
	subi $t0, $t0, 32	#subtrai 32 do valor do caracter (corresponde � sua equivalente mai�scula)
	sb $t0, ($a0)		#armazena na string
continua:
	addi $a0, $a0, 1	#k++
	j loop

fim:	la $a0, outFim
	li $v0, 4
	syscall		#imprime a string outFim
	la $a0, in
	syscall		#imprime a string alterada
	li $v0, 10
	syscall		#encerra o programa