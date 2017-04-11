	.data
	
str_Ptos: .asciiz " : "
str_puloLin: .asciiz "\n"

	.align 0 # ".align" directive cannot appear in text segment < erro no MARS
	.text

	####### Macro realiza a operacao de mod com o valor 16 em um inteiro #######
	.macro mod(%key)
	
	move $t0, %key
	addi $t1, $zero, 16
	
	loopMod:
		bgt $t1,$t0, exit_loopMod
		
		addi $t0, $t0, -16 
		
		j loopMod
		
	exit_loopMod:
	
		move $v0, $t0
	
	.end_macro

	####### Macro realiza incercao de um valor na hash #######
	.macro insertHash(%hash,%key)
	
		# Encotra a qual entrada hash a chave corresponde
		mod(%key)
		# guarda a entrada hash		
		move $s5, $v0
		
				
		# encontra o endereco correspondente a entrada hash 
		mul $s5, $s5, 4
		add $s5, %hash, $s5
				
		#insere a chave na entrada hash correspondente
		insertList($s5,%key)
	
	.end_macro
	
	####### Macro realiza a busca de um valor na hash #######
	.macro searchHash(%hash,%key)
	
		# Encotra a qual entrada hash a chave corresponde
		mod(%key)
		# guarda a entrada hash		
		move $s4, $v0
		
				
		# encontra o endereco correspondente a entrada hash 
		mul $s5, $s4, 4
		add $s5, %hash, $s5
				
		#insere a chave na entrada hash correspondente
		searchList($s5,%key)
	
		#Analiza se o valor foi encontrado
		beq $v0, 0, keyNotFound
		beq $v0, 1, keyFound
					
	keyNotFound: # caso o valor nao foi encontrado imprime -1
	
		addi $a0, $zero, -1
			
		j exit_search
				
	keyFound:  # Caso o valor for encontrado imprime a entrada hash
	
		move $a0, $s4

	exit_search:
		
		li $v0, 1
		syscall
		
	.end_macro
	
	####### Macro realiza remocao de um valor na hash #######
	.macro removeHash(%hash,%key)
		
		# Encotra a qual entrada hash a chave corresponde
		mod(%key)
		# guarda a entrada hash		
		move $s5, $v0
		
				
		# encontra o endereco correspondente a entrada hash 
		mul $s5, $s5, 4
		add $s5, %hash, $s5
				
		#insere a chave na entrada hash correspondente
		removeList($s5,%key)
	
		
	.end_macro
	

	####### Macro imprime todas entradas e todas as colicoes respectivas da HashTable #######
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
				