.data
	#sem static data (não faz sentido existir)
str_rola: .asciiz "Rola"

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
	
	.macro insertList (%list, %key) # list = &header
		createNode(%key) #criei um novo nó (retorno em $v0)
		move $s0, $v0 # $s0 contém o endereço do novo nó
		
		addi $s1,%list,0 # $s1 agora tem o next de header
 
		lw $t0,4($s1) # $t0 agora tem o valor de next de header
	
	while:	beq $t0,-1, insertNode # while(aux != header) quando sair vamos inserir
		rola
		lw $t1,4($s1) #	$t1 tem o valor do nó
		
		blt $t1,%key,insertNode # se o valor do nó for maior que key insert
		lw $s1,0($s1)
		move $t0,$t1
		
		j while
	
	insertNode:
		# $s1 = aux
		# $s0 = newNode
		sw $s1,0($s0) # newNode->next = aux
		lw $t0,8($s1) # $t0 = aux->previous
		sw $t0,8($s0) # newNode->previous = aux->previous
		
		sw $s0,0($t0) # aux->previous->next = newNode
		sw $s0,8($s1) # aux->previous = newNode	
	.end_macro
	
	.macro rola
		la $a0, str_rola
		li $v0, 4
		syscall		
	.end_macro	
		
	
