.data
out:	.asciiz "Insira a string a ser codificada: "
in:	.space 100
outCod:	.asciiz "String codificada: "

.text
main:	la $a0, out	
	li $v0, 4
	syscall		#imprime a mensagem pra inser��o de string
	la $a0, in
	li $a1, 50
	li $v0, 8
	syscall		#l� string de 100 caracteres
codificar:
	lb $t0, ($a0)		#t0 = in[k]
	beqz $t0, fim		
	beq $t0, 10, fim	#condi��es para sair do loop
	blt $t0, 65, continua
	ble $t0, 86, muda
	ble $t0, 90, mudm
	blt $t0, 97, continua
	bgt $t0, 118, wxyz	#se o valor do caracter n�o estiver entre 97 e 118 (a at� v) (ou entre 65 e 86, para letras mai�sculas), vai para outra etapa
muda:	addi $t0, $t0, 4	#adiciona 4 ao valor do caracter
	sb $t0, ($a0)		#armazena na string
continua:
	addi $a0, $a0, 1	#k++
	j codificar
wxyz:	bgt $t0, 122, continua	#if(t0 > 'z'), n�o executa essa etapa
mudm:	subi $t0, $t0, 22	#se a letra for wxyz, subtrai 22 para que ela se torne abcd respectivamente
	sb $t0, ($a0)
	j continua
	
fim:	la $a0, outCod
	li $v0, 4
	syscall		#imprime a string outFim
	la $a0, in
	syscall		#imprime a string alterada
	li $v0, 10
	syscall		#encerra o programa