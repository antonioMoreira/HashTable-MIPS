.include "doublylinkedlist.asm"
.include "menu.asm"

	.data
	.align 0
		
	.align 2
	
hashTable: .space 64 # 4(endereço) * 16 (posições da Hash)
sizeHash:	.word 16

	.text
	.globl main

main:

	# $t7 esta sendo usado para garantir que não está sendo registradores temporários não 
	# estão sendo usados nas macros
	
	li $t7, 0 #váriável para o loop
	la $s7, hashTable # $s7 contem o vetor de listas chamado comumente de Hashtable
				
#inicializa a hashTable alocada na Static Data para cada posição da hash [0,15] cria uma lista vazia	
createHash: beq $t7, 16, exit_createHash # for(i=0; i<16;i++)
	createList #em $v0 o retorno do nó header
	
	# salva o endereço de header(nova lista) em determinada posição da hash [0,15] dada por $t0
	# $t1 usado como auxiliar para evitar manipulação de $s7 (ponteiro pra Hash)
	mul $t1, $t7, 4 #t1 = $t7 * 4
	add $t1, $s7, $t1 # t1 recebe $s7 descolcado t1 vezes
	sw $v0, 0($t1) # armazena o retorno de "createList" em Static Data		
		
	addi $t7, $t7, 1 #   $t7 += 1
	
	j createHash
#Sai do loop de criação e inicialização da hash	
exit_createHash:
	
#Realiza o gerenciamento da hash	
menu:	printString(str_menu) # Printa o menu
	readInt # Pega a opção do usuário e retorna em $v0
	move $t7,$v0 # $t7 tem agora a opção 
	
	# Agora implementar um switch concatenação de vários branch if equal
	
	beq $t7, 1, insertHash # se $t7 for igual a insert(1) ir pra inserção
	beq $t7, 2, deleteHash # se $t7 for igual a delete(2) ir para a remoção
	beq $t7, 3, searchHash # se $t7 for igual a search(3) ir para a busca
	beq $t7, 4, printHash # se $t7 for igual a printHash(4) printa a hashtable inteira
	beq $t7, 5, exitMenu # se $t7 for igual a exit(5) sair pra fim do programa
	
	j menu
	
# Insere uma chave na hashtable dada a função de hashing key % size	
insertHash:
	# Print o set de strings para insert
	printString(str_typeKey)
	printString(str_insert)
	# Scaneia a chave
	readInt
	
	lw $t6,sizeHash # $t6 = 16
	move $t5,$v0 # $t5 é a chave agora	
	
	div $t5,$t6 # chave / tamanho da hash	
	mfhi $t6 # $t6 agora é mod da chave e tamanho da hash (chave % tamanho)
	mul $t6,$t6,4 # multiplica o valor de $t6 por 4 assim achamos a posição relativa em qual acessaremos $s7
	
	add $t6,$s7,$t6 # $t6 recebe $s7(base) mais $t6 
	
	insertList($t6,$t5)	 
	
	j menu

# Deleta em O(N) da hash	
deleteHash:
	# Print o set de strings para delete
	printString(str_typeKey)
	printString(str_delete)
	# Scaneia a chave
	readInt
	
	lw $t6,sizeHash # $t6 = 16
	move $t5,$v0 # $t5 é a chave agora	
	
	div $t5,$t6 # chave / tamanho da hash	
	mfhi $t6 # $t6 agora é mod da chave e tamanho da hash (chave % tamanho)
	mul $t6,$t6,4 # multiplica o valor de $t6 por 4 assim achamos a posição relativa em qual acessaremos $s7
	
	add $t6,$s7,$t6 # $t6 recebe $s7(base) mais $t6 
	
	deleteList($t6,$t5)	 
	
	j menu

# Faz uma busca O(N) na hash	
searchHash:
	# Print o set de strings para search
	printString(str_typeKey)
	printString(str_search)
	# Scaneia a chave
	readInt
	
	lw $t6,sizeHash # $t6 = 16
	move $t5,$v0 # $t5 é a chave agora	
	
	div $t5,$t6 # chave / tamanho da hash	
	mfhi $t6 # $t6 agora é mod da chave e tamanho da hash (chave % tamanho)
	mul $t6,$t6,4 # multiplica o valor de $t6 por 4 assim achamos a posição relativa em qual acessaremos $s7
	
	add $t6,$s7,$t6 # $t6 recebe $s7(base) mais $t6 
	
	searchList($t6,$t5)	 
	
	move $t4,$v0 # $t4 agora tem se a cheve foi encontrada ou não na hashtable
	
	printString(str_truefalse) # explica 1 ou 0
	printString(str_lbracket) # printa [
	printInt($t4) # printa se 1 ou 0
	printString(str_rbracket) # printa ]
	
	j menu

printHash:
	li $t7,0 # contador do loop
	
printAlllists: beq $t7,16,exitPrintAlllists # for(i = 0 ; i < 16 ; i++)
	mul $t6,$t7,4 # $t6 = 4*$t7
	add $t6,$s7,$t6 # $t6 recebe $s7(base) mais $t6
	printList($t6) # printa a lista que ta em $t6
	
	addi $t7,$t7,1 # $t7++
	
	j printAlllists
	
# Sai do loop de printar toda a hash	
exitPrintAlllists: j menu	
	
#Chama a macro exit que faz $v0 = 10 e da syscall		
exitMenu:					
	exit	
	
	
	
