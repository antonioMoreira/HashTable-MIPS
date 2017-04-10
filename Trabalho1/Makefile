all: linkedList.o HashTable.o fullcompile clean

compile:
	@gcc linkedList.o HashTable.o -o hash

fullcompile:
	@gcc linkedList.o HashTable.o -o hash -g -Wall

linkedList.o:
	@gcc -c linkedList.c

HashTable.o:
	@gcc -c HashTable.c

clean:
	@rm -- *.o

run:
	@./hash

fullrun:
	@valgrind -v --track-origins=yes --leak-check=full --show-leak-kinds=all ./hash

zip:
	zip -r hash *.c *.h Makefile