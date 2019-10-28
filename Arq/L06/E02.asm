.data
out:	.asciiz "Insira a string: "
outFim:	.asciiz "Nova string: "
in:	.space 50

.text
main:	la $a0, out	
	li $v0, 4
	syscall		#imprime a mensagem pra inserção de string
	la $a0, in
	li $a1, 50
	li $v0, 8
	syscall		#lê string de 50 caracteres
loop:	lb $t0, ($a0)		#t0 = in[k]
	beqz $t0, fim		
	beq $t0, 10, fim	#condições para sair do loop
	blt $t0, 97, continua
	bgt $t0, 122, continua	#se o valor do caracter não estiver entre 97 e 122 (a até z), pula a etapa de alterá-lo
	subi $t0, $t0, 32	#subtrai 32 do valor do caracter (corresponde à sua equivalente maiúscula)
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