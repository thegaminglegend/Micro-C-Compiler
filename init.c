#include "global.h"
#include "mycc.h"

struct Keyword
{	char *lexptr;
	int token;
};

static struct Keyword keywords[] =
{
	{ "break",	BREAK },
	{ "do",		DO },
	{ "else",	ELSE },
	{ "for",	FOR },
	{ "if",		IF },
	{ "return",	RETURN },
	{ "while",	WHILE },
	{ NULL,         0 }
};

/* init - populates global symbol table with keywords */
void init()
{
	struct Keyword *k;
	Symbol *p;

	for (k = keywords; k->lexptr; k++)
		
		p = insert(k->lexptr, k->token);
		p->localvar = -1;
}

