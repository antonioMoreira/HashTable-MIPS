	.data
	#sem static data (não faz sentido existir)
str_debug: .asciiz "@@@\n"

	.align 2 # ".align" directive cannot appear in text segment < erro no MARS
	.text
	
	# Argumento key passado como 16-bit immediate
	.macro createNode(%key)
		# Definição de node ↓
		#	endereço proximo
		#	numero	
		#	endereço anterior
	
		li $v0, 9 #sbrk
		li $a0, 12 # aloquei 12 bytes
		syscall # está em $v0 o endereço alocado
		
		move $t0,%key
		move $t1, $v0
		
		sw $t0, 4($t1)	
		
	.end_macro
	
	# Macro que retorna um header com -1 e circular
	.macro createList
		li $t0,-1
		createNode($t0)
		move $s0, $v0
		
		# Os dois store-word's garantem a circularidade da lista
				
		#salva o endereço de s0 na primeira posicao
		sw $s0, 0($s0)
				
		#salva o endereço de s0 na ultima opção
		sw $s0, 8($s0)
		
		move $v0, $s0 # retorno o endereço do header
	.end_macro	
	
	# Macro de inserção ordenada na lista
	.macro insertList (%list, %key) # list = &header
		createNode(%key) #criei um novo nó (retorno em $v0)
		move $s0, $v0 # $s0 contém o endereço do novo nó
		
		lw $s1,0(%list) # $s1 agora é header
 		lw $s1,0($s1) # $s1 agora header->next
		lw $t0,4($s1) # $t0 agora tem o valor de next de header
	
	# while( aux != header && aux->number < key )						
	whileInsert: beq $t0,-1, insertNode # while(aux != header) quando sair vamos inserir
				
		bgt $t0,%key,insertNode # se o valor do nó for maior que key insert
		
		lw $s1,0($s1) # aux = aux-> next
		lw $t0,4($s1) # aux->number = aux->next->number		
		
		j whileInsert
	
	# Insere na lista de modo ordenado
	insertNode:
		# $s1 = aux
		# $s0 = newNode
		sw $s1,0($s0) # newNode->next = aux
		lw $t0,8($s1) # $t0 = aux->previous
		sw $t0,8($s0) # newNode->previous = aux->previous
		
		sw $s0,0($t0) # aux->previous->next = newNode
		sw $s0,8($s1) # aux->previous = newNode	
	.end_macro
	
	# Macro de busca na lista ordenaada
	.macro searchList (%list, %key) # list = &header
		lw $s1,0(%list) # $s1 agora é header
 		lw $s1,0($s1) # $s1 agora header->next
		lw $t0,4($s1) # $t0 agora tem o valor de next de header
		
		li $v0,0 # $v0 = 0
		
	# while( aux != header && aux->number != key )						
	whileSearch: beq $t0,-1, notFound # while(aux != header) quando sair não acharmos
		
		beq $t0,%key,found # se o valor do nó for igual a key achamos
		
		lw $s1,0($s1) # aux = aux-> next
		lw $t0,4($s1) # aux->number = aux->next->number		
		
		j whileSearch
	
			
	# Achamos então retornamos 1 (true)
	found:
		li $v0,1 # $v0 = 1	
		
	# Não achamos então retornamos 0 (false)
	notFound: # $v0 ja tem 0	
	.end_macro
	
	.macro debug
		la $a0, str_debug
		li $v0, 4
		syscall		
	.end_macro	
	
	# Macro de busca na lista ordenaada
	.macro deleteList (%list, %key) # list = &header
		lw $s1,0(%list) # $s1 agora é header
 		lw $s1,0($s1) # $s1 agora header->next
		lw $t0,4($s1) # $t0 agora tem o valor de next de header
		
	# while( aux != header && aux->number != key )						
	whileDelete: beq $t0,-1, dontDelete # while(aux != header) quando sair não acharmos
		
		beq $t0,%key,delete # se o valor do nó for igual a key achamos
		
		lw $s1,0($s1) # aux = aux-> next
		lw $t0,4($s1) # aux->number = aux->next->number		
		
		j whileDelete	
			
	# Achamos então removemos
	delete:
		# $s1 = nodeRemove
		lw $t0,8($s1) # $t0 = nodeRemove->previous
		lw $t1,0($s1) # $t1 = nodeRemove->next
		
		sw $t1,0($t0)	#nodeRemove->previous->next = nodeRemove->next;
		sw $t0,8($t1)	#nodeRemove->next->previous = nodeRemove->previous;
		
	# Não achou então nao remove nada
	dontDelete: 	
	.end_macro
	
	# Macro que printa uma lista ordenaada
	.macro printList (%list) # list = &header
		lw $s1,0(%list) # $s1 agora é header
 		lw $s1,0($s1) # $s1 agora header->next
		lw $t0,4($s1) # $t0 agora tem o valor de next de header
		
		li $t1,-1
		printString(str_lbracket)
		printInt($t1)
	# while( aux != header && aux->number != key )						
	whilePrint: beq $t0,-1, exitPrintlist # while(aux != header) quando sair acabou a lista
		printString(str_space)
		printString(str_arrow)
		printInt($t0) #printa o valor do nó				
		lw $s1,0($s1) # aux = aux-> next
		lw $t0,4($s1) # aux->number = aux->next->number		
		
		j whilePrint	
		
	# Sai do loop/macro
	exitPrintlist:
		printString(str_rbracket)
	.end_macro
	
	# String pra debugar o código
	.macro debug
		la $a0, str_debug
		li $v0, 4
		syscall		
	.end_macro	
		
	
	
