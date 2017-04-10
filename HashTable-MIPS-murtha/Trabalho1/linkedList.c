#include <stdio.h>
#include <stdlib.h>

#include "linkedList.h"

/*

		Lista ligada duplamente encadeada circular com nó cabeça e
	inserção ordenada.


	caracteriza a circularidade									  caracteriza a circularidade			
	↑															  ↑
	← [ H ] ←→ [ a ] ←→ [ b ] ←→ [ c ] ←→ [ d ] ←→ [ e ] ←→ [ f ] → 
		↑ Header	           ↑
						identifica o duplo encadeamento

	onde, [ a > b > ... > f ]


	Funções implementadas:
		 » Criação
		 » Inserção
		 » Busca
		 » Remoção
		 » Apagar

*/

struct node{
	// Sempre alocar com sbrk (9 nas syscall's) 12 bytes
	//	$v0 contém o endereço do local alocado na Dynamic Data

	NODE *next; // 4 bytes em MIPS
	int number; // 4 bytes em MIPS
	NODE *previous; // 4 bytes em MIPS
};


void deleteNode(NODE **node){

	if(node != NULL && (*node) != NULL){
		free(*node);
		(*node) = NULL;
	}
}

NODE *createNode(int number){
	NODE *newNode = (NODE *)malloc(sizeof(NODE));

	if(newNode != NULL){
		newNode->next = newNode;
		newNode->previous = newNode;
		newNode->number = number;
	}

	return newNode;
}

void deleteLList(L_LIST **list){
	NODE *nodeAux, *nodeDelete;

	if(list != NULL && (*list) != NULL){
		nodeAux = (*list)->header->next;

		while(nodeAux != (*list)->header){
			nodeDelete = nodeAux;
			nodeAux = nodeAux->next;

			deleteNode(&nodeDelete);
		}

		deleteNode(&(*list)->header);

		free(*list);

		*list = NULL;
	}
}

L_LIST *createLList(){
	L_LIST *newLList = (L_LIST *)malloc(sizeof(L_LIST));

	if(newLList != NULL)
		newLList->header = createNode(-1); // inserção sempre será > 0

	return newLList;
}

void insertLList(L_LIST *list, int number){
	//inserção ordenada na lista (Insertion-sort) [Custo: O(n)]
	NODE *newNode, *aux;

	if(list != NULL){
		newNode = createNode(number);

		if(newNode != NULL){
			aux = list->header->next;

			while(aux != list->header && aux->number < number)
				aux = aux->next;

			newNode->next = aux;
			newNode->previous = aux->previous;

			aux->previous->next = newNode;
			aux->previous = newNode;

		}
	}
}

int searchLList(L_LIST *list, int number){
	NODE *nodeSearch;

	if(list != NULL){
		nodeSearch = list->header->next;

		while(nodeSearch != list->header && nodeSearch->number < number)
			nodeSearch = nodeSearch->next;

		if(nodeSearch->number == number)
			return 1;
	}

	return -1;
}

NODE *searchLListNode(L_LIST *list, int number){
	NODE *nodeSearch;

	if(list != NULL){
		nodeSearch = list->header->next;

		while(nodeSearch != list->header && nodeSearch->number < number)
			nodeSearch = nodeSearch->next;

		if(nodeSearch->number == number)
			return nodeSearch;
	}

	return NULL;
}

void removeLList(L_LIST *list, int number){
	NODE *nodeRemove;

	if(list != NULL){
		nodeRemove = searchLListNode(list, number);

		if(nodeRemove != NULL){
			nodeRemove->previous->next = nodeRemove->next;
			nodeRemove->next->previous = nodeRemove->previous;

			deleteNode(&nodeRemove);
		}
	}
}

void printLList(L_LIST *list){
	NODE *auxPrint;

	if(list != NULL){
		auxPrint = list->header->next;

		while(auxPrint != list->header){
			printf("[%d] ←→ ", auxPrint->number);
			auxPrint = auxPrint->next;
		}

		printf("\n");
	}
}