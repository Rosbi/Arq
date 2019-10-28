.data
out:	.asciiz "Insira a string: "
in:	.word 50
nPalin:	.asciiz "Palindromo"
sPalin:	.asciiz "Nao palindromo"
.text
main:	la $a0, out	
	li $v0, 4
	syscall		#imprime a mensagem pra inserção de string
	la $a0, in
	li $a1, 50
	li $v0, 8
	syscall		#lê string de 50 caracteres
	move $a1, $a0	#deixa a posição inicial em a0 e a1
loop:	lb $t0, ($a1)	#t0 = in[i]
	beqz $t0, palin	
	beq $t0, 10, palin	#if(t0 == 0 || t0 == '\n') jump palin	
	addi $a1, $a1, 1	#else i++
	j loop
palin:	subi $a1, $a1, 1	#in[i] == '\0', portanto i--
loopPalin:
	lb $t0, ($a1)	#t0 = in[i], começando do ultimo caracter da string
	lb $t1, ($a0)	#t1 = in[j], começando do primeiro caracter da string
	beqz $t1, true
	beq $t1, 10, true	#if(t1 == 0 || t1 == '\n') jump true
	bne $t0, $t1, false	#if(t1 != t2) jump false
	addi $a0, $a0, 1	#i--
	subi $a1, $a1, 1	#j++
	j loopPalin
false:	la $a0, sPalin
	li $v0, 4
	syscall		#imprime que não é palíndromo
	j fim
true:	la $a0, nPalin
	li $v0, 4
	syscall		#imprime que é palíndromo
fim:	li $v0, 10
	syscall		#encerra o programa