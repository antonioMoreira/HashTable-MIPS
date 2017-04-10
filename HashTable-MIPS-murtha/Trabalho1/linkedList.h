#ifndef LINKED_LIST_H
#define LINKED_LIST_H

typedef struct node NODE;

typedef struct l_list{
	NODE *header;
}L_LIST;

L_LIST *createLList();

void deleteLList(L_LIST **);

void insertLList(L_LIST *, int);

int searchLList(L_LIST *, int);

void removeLList(L_LIST *, int);

void printLList(L_LIST *);

#endif