.data
	#sem static data (não faz sentido existir)
str_debug: .asciiz "@@@\n"
str_puloLin: .asciiz "\n"
str_virgula: .asciiz ", "
str_Ptos: .asciiz " : "

.align 0 # ".align" directive cannot appear in text segment < erro no MARS
.text
	
	.macro done
		li $v0,10
		syscall
	.end_macro
	
	# Argumento key passado como 16-bit immediate
	.macro createNode(%key)
		# Definição de node ↓
		#	endereço proximo
		#	numero	
		#	endereço anterior
	
		li $v0, 9 #sbrk
		li $a0, 12 # aloquei 12 bytes
		syscall # está em $v0 o endereço alocado
		
		li $t0,%key
		move $t1, $v0
		
		sw $t0, 4($t1)	
		
	.end_macro
	
	# Macro que retorna um header com -1 e circular
	.macro createList
		createNode(-1)
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
	while:	beq $t0,-1, insertNode # while(aux != header) quando sair vamos inserir
				
		bgt $t0,%key,insertNode # se o valor do nó for maior que key insert
		
		lw $s1,0($s1) # aux = aux-> next
		lw $t0,4($s1) # aux->number = aux->next->number		
		
		j while
	
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
	
	.macro debug
		la $a0, str_debug
		li $v0, 4
		syscall		
	.end_macro	
		
	
	.macro printAllList(%list)
	
		# carrega o primeiro valor pulando o header
		lw $s2, 0(%list)
		lw $t1, 4($s2)
	
	loopAllList: beq $t1, -1, exit_loopAllList
	
		# imprime o item atual
		li $v0, 1
		move $a0, $t1
		syscall
	
		#imprime uma virgula separando os valores da colisao
		li $v0, 4
		la $a0, str_virgula
		syscall
	
		# carrega o proximo item da lista
		lw $s2, 0($s2)
		lw $t1, 4($s2) 		
  	
  		j loopAllList
  	
	exit_loopAllList:    

			
	.end_macro						
	
					
									
																	
	.macro printAllHash(%hash)

		# Guarda o valor da primeira entrada da hash para percorre-la
		move $s0, %hash
	
		# Percorre a hash printando cada lista referente a cada entrada 	
		li $t0, 0
	loopPrintAll: beq $t0, 16, exit_loopPrintAll	
	
		# imprime a entrada hash atual
		li $v0, 1
		move $a0, $t0
		syscall
	
		# imprime os dois pontos para diferenciar a entrada hash dos valores da lista de colisoes
		li $v0, 4
		la $a0, str_Ptos
		syscall
	
		# Carrega o endereco apontado para a entrada hash atual
		mul $t1, $t0, 4
		add $t1, $t1, $s0
		lw $s1, 0($t1) # Carrga o header da lista
	
		# Impressao da lista de colisoes
		printAllList($s1)
	
		# Pulando uma linha para a proxima impressao
		li $v0, 4
		la $a0, str_puloLin
		syscall	
	
	
		addi $t0, $t0, 1
	
		j loopPrintAll	
				
	exit_loopPrintAll:

		# Pulo de linha para difereciar de proximos comandos
		li $v0, 4
		la $a0, str_puloLin
		syscall

	.end_macro
