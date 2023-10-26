#include "global.h"

// symbol table from program1
#define SYMMAX 100

// creatse an entry instance called symtable - the symbole table
struct Symbol symtable[SYMMAX];

int lastentry = 0;

/* TODO: define a symbol table/array, reuse project Pr1 */
// function to
Symbol *lookup(const char *s)
{
    int p;
    Symbol *rc = NULL;

    for (p = 0; p < lastentry; p++)
    {
        // check if s is equal to any item in the symbol table
        if (strcmp(symtable[p].lexptr, s) == 0)
        {
            // if item found equal get the address of that symbol
            rc = &symtable[p];
            break;
        }
    }
    // if not found return NULL else return its index
    return rc;
}

Symbol *insert(const char *s, int token)
{
    Symbol *rc = NULL;

    // check if symbol table is full
    if (lastentry + 1 == SYMMAX)
    {
        // print error message and exists program
        error("symbol table full");
    }

    // if symbol table is not full
    // add the symbols to the end of the table
    symtable[lastentry].token = token;

    // malloc: dynamically allocate a single large block of memory with the specified size
    symtable[lastentry].lexptr = (char *)malloc(strlen(s) + 1);
    
    strcpy(symtable[lastentry].lexptr, s);

    // get the address of the inserted token in symbol table
    rc = &symtable[lastentry];

    lastentry++;

    return rc;
}
