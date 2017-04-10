.include "macro.asm"

	.data
	.align 0 # redundante
srt_rola: .asciiz "Rolaaaaaaaaaaz\n"
	
	.align 2
hashTable: .space 64 # 4(endereço) * 16 (posições da Hash)

	.align 0 # redundante
	.text
	.globl main

main:

	# $t7 esta sendo usado para garantir que não está sendo registradores temporários não 
	# 	estão sendo usados nas macros
	
	li $t7, 0 #váriável para o loop
	la $s7, hashTable #nunca vai ser manipulado
	
loopCreateHash: beq $t7, 16, exit_loopCreate # for(i=0; i<16;i++)
	#inicializa a hashTable alocada na Static Data
	#	para cada posição da hash [0,15] cria uma lista
	createList #em $v0 o retorno do nó header
	
	# salva o endereço de header(nova lista) em determinada posição da hash [0,15] dada por $t0
	# $t1 usado como auxiliar para evitar manipulação de $s7 (ponteiro pra Hash)
	mul $t1, $t7, 4 #t1 = $t7 * 4
	add $t1, $s7, $t1 # t1 recebe $s7 descolcado t1 vezes
	sw $v0, 0($t1) # armazena o retrono de "createList" em Static Data		
		
	addi $t7, $t7, 1 #   $t7 += 1
	
	j loopCreateHash

exit_loopCreate:
	
	insertList($s7,9)
	insertList($s7,5)
	insertList($s7,2)
	insertList($s7,1)
	
		
	lw $a1,0($s7) # a0 = header
	lw $a0,4($a1) # a0 = number de header
	li $v0,1
	syscall
	
	lw $a1,0($a1) # a0 = header->next
	lw $a0,4($a1) # a0 = header->next->number
	li $v0,1
	syscall
	
	lw $a1,0($a1) # a0 = header->next
	lw $a0,4($a1) # a0 = header->next->number
	li $v0,1
	syscall
	

	li $t0, 0	
loopPrintTest: beq $t0, 16, exit_loopPrintTest 
	
	# carrega o endereco
	mul $t1, $t0, 4 # $t1 = $t0 * 4
	add $t1, $t1, $s7 #tem a posição relativa da hashTable	
	lw $a0, 0($t1) #load conteúdo do vetor hash (enderço pra header)
	
	#printar valor
	#li $v0, 1
	#lw $a0, 4($a0)
	#li $a0, 10
	#syscall
	
	addi $t0, $t0, 1

	j loopPrintTest

exit_loopPrintTest:
	
	done
	
	
