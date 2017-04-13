	.data
str_menu:	.asciiz "\n\n\t\t\t\t__HASH_MENU__\nType:\n[1]-> Insert.\t[2]-> Delete.\t[3]-> Search.\t[4]-> Print Hashtable.\t[5]-> Exit.\n"	
str_typeKey:	.asciiz "Type the key to "
str_insert:	.asciiz "insert in the hashtable.\n"
str_delete:	.asciiz "delete of the hashtable.\n"
str_search:	.asciiz "search in the hashtable.\n"
str_truefalse:	.asciiz "If the key was found in the hashtable then the next integer printed will be 1 else 0:\n"
str_lbracket:	.asciiz "["
str_rbracket:	.asciiz "]\n"
str_comma:	.asciiz ","
str_space:	.asciiz " "
str_arrow:	.asciiz "-> "

	.align 2 # ".align" directive cannot appear in text segment < erro no MARS
	.text
	
	#Printa uma string generica
	.macro printString(%string)
		li $v0,4 # Print String
		la $a0,%string # Loada endereço da string
		syscall # chamada de sistema 
	.end_macro
	
	#Printa uma string generica
	.macro printInt(%int)
		li $v0,1 # Print Int
		move $a0,%int # copia o conteudo do registrador %int
		syscall # chamada de sistema 
	.end_macro
	
	#Scaneia um inteiro e o retorna em $v0 
	.macro readInt
		li $v0,5 # Read int
		syscall #chamada de sistema
		#$v0 contem o inteiro
	.end_macro	
		
	# exit e syscall
	.macro exit
		li $v0,10
		syscall
	.end_macro
			
