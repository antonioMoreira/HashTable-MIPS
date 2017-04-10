#include <stdio.h>
#include <stdlib.h>

#include "linkedList.h"

int main(int argc, char *argv[]){
	L_LIST **hashTable = (L_LIST **)malloc(sizeof(L_LIST*)*(16));
	int i, command, key, aux;

	for(i=0; i<16; i++) hashTable[i] = createLList();

	do{
		scanf("%d", &command);

		switch(command){
			case -1: // sair do programa
				for(i=0; i<16; i++)
					deleteLList(&(hashTable[i]));
				break;

			//--------------------------------

			case 1:	//inserção
				
				do{
					scanf("%d", &key);
					if(key >= 0)
						insertLList(hashTable[key%16], key);
				}while(key != -1);

				break;

			//--------------------------------

			case 2:	//remoção
				
				do{
					scanf("%d", &key);
					if(key >= 0)
						removeLList(hashTable[key%16], key);
				}while(key != -1);

				break;

			//--------------------------------

			case 3:	//busca

				do{
					scanf("%d", &key);

					if(key >= 0){
						aux = searchLList(hashTable[key%16], key);
						if(aux == 1)
							printf("%d\n", key%16);
						else
							printf("%d\n", -1);
					}

				}while(key != -1);

				break;

			//--------------------------------

			case 4:

				for(i=0;i<16; i++){
					printf("%d > ", i);
					printLList(hashTable[i]);
				}

				break;

			//--------------------------------

			default:

				printf("Comando invalido\n");
				break;
		 	}

	}while(command != -1);

	return 0;
}