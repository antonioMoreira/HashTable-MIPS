.include "macroList.asm"
.include "macroHash.asm"

	.data
	.align 0 # redundante

str_menu: .asciiz "Menu:\n"				
str_insert: .asciiz "Insercao:\n"
str_remove: .asciiz "Remocao:\n"	
str_search: .asciiz "Busca:\n"	
					
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
	
	
########## inicializa a hashTable alocada na Static Data ##########
loopCreateHash: beq $t7, 16, exit_loopCreate # for(i=0; i<16;i++)
	
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
	
	
	
loopOperationChoose: 
	
	li $v0, 4
	la $a0, str_menu
	syscall

	# Leitura da Operacao a ser relizada
	li $v0, 5 
	syscall
	move $t7, $v0
	
	beq $t7, -1, exit_loopOperationChoose #Finaliza o programa
		
	beq $t7, 1, loopInsert #Insercao
			
	beq $t7, 2, loopRemove #remocaocao			
					
	beq $t7, 3, loopSearch #Busca
		
	beq $t7, 4, printHash #Imprime toda a hash				
		
	# Operacao invalida					
	j loopOperationChoose
		
loopInsert:
	
	li $v0, 4
	la $a0, str_insert
	syscall
	
	# Leitura da Chave a ser inserida
	li $v0, 5 
	syscall
	move $t7, $v0
	
	# Caso seja o comando de saida, -1
	beq $t7, -1, loopOperationChoose
	
	# Insere o valor digitado na hash
	insertHash($s7,$t7)						
												
	j loopInsert					

loopRemove:
	
	li $v0, 4
	la $a0, str_remove
	syscall
	
	# Leitura da Chave a ser removida
	li $v0, 5 
	syscall
	move $t7, $v0
	
	# Caso seja o comando de saida, -1
	beq $t7, -1, loopOperationChoose
	
	# Insere o valor digitado na hash
	removeHash($s7,$t7)						
												
	j loopRemove

loopSearch:
	
	li $v0, 4
	la $a0, str_search
	syscall
	
	# Leitura da Chave a ser inserida
	li $v0, 5 
	syscall
	move $t7, $v0
	
	# Caso seja o comando de saida, -1
	beq $t7, -1, loopOperationChoose
	
	# Insere o valor digitado na hash
	searchHash($s7,$t7)						
												
	j loopSearch																				

printHash:

	printAllHash($s7)
																				
	j loopOperationChoose
			
																																																																																																																																																											
exit_loopOperationChoose:				

	done
	
