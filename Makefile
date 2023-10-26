CC=cc
YACC=bison
LEX=flex
COFLAGS=-g -O2
CWFLAGS=-Wall -Wextra
CFLAGS=$(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)

all:		mycc

mycc:		mycc.c bytecode.o error.o init.o javaclass.o symbol.o lex.yy.c
		$(CC) $(CFLAGS) -o mycc mycc.c bytecode.o error.o init.o javaclass.o lex.yy.c symbol.o $(LIBS)

mycc.c:		mycc.l mycc.y
		$(LEX) --header-file=lex.yy.h mycc.l
		$(YACC) -o mycc.c -d -v mycc.y

bytecode.o:	bytecode.c javaclass.h bytecode.h
		$(CC) $(CFLAGS) -c bytecode.c

error.o:	error.c global.h
		$(CC) $(CFLAGS) -c error.c

init.o:		init.c global.h mycc.h mycc.c
		$(CC) $(CFLAGS) -c init.c

javaclass.o:	javaclass.c javaclass.h
		$(CC) $(CFLAGS) -c javaclass.c

symbol.o:	symbol.c global.h
		$(CC) $(CFLAGS) -c symbol.c



.PHONY:		clean distclean
clean:
		-rm -f *.o mycc.c lex.yy.c mycc.h
distclean:
		-rm -f mycc *.o mycc.h mycc.c lex.yy.h lex.yy.c mycc.output Code.class
