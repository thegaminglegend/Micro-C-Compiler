%{

#include "lex.yy.h"
#include "global.h"
static struct ClassFile cf;

%}

/* declares YYSTYPE type of attribute for all tokens and nonterminals */
%union
{ Symbol *sym;  /* token value yylval.sym is the symbol table entry of an ID */
  unsigned num; /* token value yylval.num is the value of an int constant */
  float flt;    /* token value yylval.flt is the value of a float constant */
  char *str;    /* token value yylval.str is the value of a string constant */
  unsigned loc; /* location of instruction to backpatch */
}

/* Declare ID token and its attribute type 'sym' */
%token <sym> ID

/* Declare INT tokens (8 bit, 16 bit, 32 bit) and their attribute type 'num' */
%token <num> INT8 INT16 INT32

/* Declare FLT token (not used in this assignment) */
%token <flt> FLT

/* Declare STR token (not used in this assignment) */
%token <str> STR

/* Declare tokens for keywords */
/* Note: install_id() returns Symbol* for both keywords and identifiers */
%token <sym> BREAK DO ELSE FOR IF RETURN WHILE

/* Declare operator tokens */
/* ASSOCIATIVITY AND PRECEDENCE DECLARATIONS */
%token PA NA TA DA MA AA XA OA LA RA OR AN EQ NE LE GE LS RS AR PP NN

%right '=' PA NA TA DA MA LA RA AA XA OA
%left OR
%left AN
%left '|'
%left '^'
%left '&'
%left EQ NE
%left '>' '<' LE GE 
%left LS RS
%left '+' '-'
%left '*' '/' '%'
%right '!' '~'
%left AR PP NN

/* Declare attribute types for marker nonterminals, such as L M and N */
%type <loc> L M N P

%%

stmts   : stmts stmt
        | /* empty */
        ;

stmt    : ';'
        | expr ';'      { emit(pop); /* do not leave a value on the stack */ }
        | IF '(' expr M N')' L stmt
                        { backpatch($4, pc-$4); /* if expr false go to end */
                          backpatch($5, $7-$5); /* if expr true go to stmt */
                        }
        | IF '(' expr M N ')' L stmt ELSE N L stmt
                        { backpatch($4, $11-$4); /* if expr false go to 2nd stmt  */
                          backpatch($5, $7-$5); /* if expr true go to 1st stmt */
                          backpatch($10, pc-$10); /* after 1st stmt go to end */
                         
                        }
        | WHILE '(' L expr M N ')' L stmt N
                        { backpatch($5, pc-$5); /* if expr false go to end */
                          backpatch($6, $8-$6); /* if expr true go to stmt */
                          backpatch($10, $3-$10); /* after stmt go back to expr */
                        }
        | DO L stmt WHILE '(' L expr M N ')' ';'
                        { backpatch($8, pc-$8); /* if expr false go to end */
                          backpatch($9, $2-$9); /* if expr true go back to stmt */
                        }

        | FOR '(' expr P ';' L expr M N ';' L expr P N ')' L stmt N
                        { backpatch($8, pc-$8); /* if 2nd expr false go to end */
                          backpatch($9, $16-$9); /* if 2nd expr true go to stmt */
                          backpatch($14, $6-$14); /* after 3rd expr go back to 2nd expr */
                          backpatch($18, $11-$18); /* after stmt go to 3rd expr */
                        }

        | RETURN expr ';'
                        { emit(istore_2); /* return val goes in local var 2 */ }
        | BREAK ';'
                        { /* TODO: BONUS!!! */ error("break not implemented"); }
        | '{' stmts '}'
        | error ';'     { yyerrok; }
        ;

expr    : ID   '=' expr { emit(dup); emit2(istore, $1->localvar); }
        | ID   PA  expr { emit2(iload, $1->localvar); emit(iadd); emit(dup); emit2(istore, $1->localvar); }
        | ID   NA  expr { emit2(iload, $1->localvar); emit(swap); emit(isub); emit(dup); emit2(istore, $1->localvar); }
        | ID   TA  expr { emit2(iload, $1->localvar); emit(imul); emit(dup); emit2(istore, $1->localvar); }
        | ID   DA  expr { emit2(iload, $1->localvar); emit(swap); emit(idiv); emit(dup); emit2(istore, $1->localvar); }
        | ID   MA  expr { emit2(iload, $1->localvar); emit(swap); emit(irem); emit(dup); emit2(istore, $1->localvar); }
        | ID   AA  expr { emit2(iload, $1->localvar); emit(swap); emit(iand); emit(dup); emit2(istore, $1->localvar); }
        | ID   XA  expr { emit2(iload, $1->localvar); emit(swap); emit(ixor); emit(dup); emit2(istore, $1->localvar); }
        | ID   OA  expr { emit2(iload, $1->localvar); emit(swap); emit(ior); emit(dup); emit2(istore, $1->localvar); }
        | ID   LA  expr { emit2(iload, $1->localvar); emit(swap); emit(ishl); emit(dup); emit2(istore, $1->localvar); }
        | ID   RA  expr { emit2(iload, $1->localvar); emit(swap); emit(ishr); emit(dup); emit2(istore, $1->localvar); }
        | expr OR  expr { emit(ior);}
        | expr AN  expr { emit(iand); }
        | expr '|' expr { emit(ior); }
        | expr '^' expr { emit(ixor); }
        | expr '&' expr { emit(iand); }
        | expr EQ  expr { emit3(if_icmpeq, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr NE  expr { emit3(if_icmpne, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr '<' expr { emit3(if_icmplt, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr '>' expr { emit3(if_icmpgt, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr LE  expr { emit3(if_icmple, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr GE  expr { emit3(if_icmpge, 7); emit(iconst_0); emit3(goto_, 4); emit(iconst_1); }
        | expr LS  expr { emit(ishl); }
        | expr RS  expr { emit(ishr); }
        | expr '+' expr { emit(iadd); }
        | expr '-' expr { emit(isub); }
        | expr '*' expr { emit(imul); }
        | expr '/' expr { emit(idiv); }
        | expr '%' expr { emit(irem); }
        | '!' expr      { emit(ineg); }
        | '~' expr      { emit(ineg); }
        | '+' expr %prec '!' /* '+' at same precedence level as '!' */
                        { /*No need to do*/ }
        | '-' expr %prec '!' /* '-' at same precedence level as '!' */
                        { emit(ineg); }
        | '(' expr ')'
        | '$' INT8      { emit(aload_1); emit2(bipush, $2); emit(iaload); }
        | PP ID         { emit32(iinc, $2->localvar, 1); emit2(iload, $2->localvar); }
        | NN ID         { emit32(iinc, $2->localvar, -1); emit2(iload, $2->localvar); }
        | ID PP         { emit2(iload, $1->localvar); emit32(iinc, $1->localvar, 1); }
        | ID NN         { emit2(iload, $1->localvar); emit32(iinc, $1->localvar, -1); }
        | ID            { emit2(iload, $1->localvar); }
        | INT8          { emit2(bipush, $1); }
        | INT16         { emit3(sipush, $1); }
        | INT32         { emit2(ldc, constant_pool_add_Integer(&cf, $1)); }
	| FLT		{ error("float constant not supported in Pr3"); }
	| STR		{ error("string constant not supported in Pr3"); }
        ;

L       : /* empty */   { $$ = pc; }
        ;

M       : /* empty */   { $$ = pc;	/* location of inst. to backpatch */
			  emit3(ifeq, 0);
			}
        ;

N       : /* empty */   { $$ = pc;	/* location of inst. to backpatch */
			  emit3(goto_, 0);
			}
        ;

P       :               { emit(pop);	/* do not leave a value on the stack */ 
                        }
        ;

%%

int main(int argc, char **argv)
{
	int index1, index2, index3;
	int label1, label2;

	// set up new class file structure
	init_ClassFile(&cf);

	// class has public access
	cf.access = ACC_PUBLIC;

	// class name is "Code"
	cf.name = "Code";

	// no fields
	cf.field_count = 0;

	// one method
	cf.method_count = 1;

	// allocate array of methods (just one "main" in our example)
	cf.methods = (struct MethodInfo*)malloc(cf.method_count * sizeof(struct MethodInfo));

	if (!cf.methods)
		error("Out of memory");

	// method has public access and is static
	cf.methods[0].access = (enum access_flags)(ACC_PUBLIC | ACC_STATIC);

	// method name is "main"
	cf.methods[0].name = "main";

	// method descriptor of "void main(String[] arg)"
	cf.methods[0].descriptor = "([Ljava/lang/String;)V";

	// max operand stack size of this method
	cf.methods[0].max_stack = 100;

	// the number of local variables in the local variable array
	//   local variable 0 contains "arg"
	//   local variable 1 contains "val"
	//   local variable 2 contains "i" and "result"
	cf.methods[0].max_locals = 100;

	// set up new bytecode buffer
	init_code();
	
	// generate prologue code

/*LOC*/ /*CODE*/			/*SOURCE*/
/*000*/	emit(aload_0);
/*001*/	emit(arraylength);		// arg.length
/*002*/	emit2(newarray, T_INT);
/*004*/	emit(astore_1);			// val = new int[arg.length]
/*005*/	emit(iconst_0);
/*006*/	emit(istore_2);			// i = 0
	label1 = pc;			// label1:
/*007*/	emit(iload_2);
/*008*/	emit(aload_0);
/*009*/	emit(arraylength);
	label2 = pc;
/*010*/	emit3(if_icmpge, PAD);		// if i >= arg.length then goto label2
/*013*/	emit(aload_1);
/*014*/	emit(iload_2);
/*015*/	emit(aload_0);
/*016*/	emit(iload_2);
/*017*/	emit(aaload);			// push arg[i] parameter for parseInt
	index1 = constant_pool_add_Methodref(&cf, "java/lang/Integer", "parseInt", "(Ljava/lang/String;)I");
/*018*/	emit3(invokestatic, index1);	// invoke Integer.parseInt(arg[i])
/*021*/	emit(iastore);			// val[i] = Integer.parseInt(arg[i])
/*022*/	emit32(iinc, 2, 1);		// i++
/*025*/	emit3(goto_, label1 - pc);	// goto label1
	backpatch(label2, pc - label2);	// label2:

	// end of prologue code

	init();

	if (argc > 1)
		if (!(yyin = fopen(argv[1], "r")))
			error("Cannot open file for reading");

	if (yyparse() || errnum > 0)
		error("Compilation errors: class file not saved");

	fprintf(stderr, "Compilation successful: saving %s.class\n", cf.name);

	// generate epilogue code

	index2 = constant_pool_add_Fieldref(&cf, "java/lang/System", "out", "Ljava/io/PrintStream;");
/*036*/	emit3(getstatic, index2);	// get static field System.out of type PrintStream
/*039*/	emit(iload_2);			// push parameter for println()
	index3 = constant_pool_add_Methodref(&cf, "java/io/PrintStream", "println", "(I)V");
/*040*/	emit3(invokevirtual, index3);	// invoke System.out.println(result)
/*043*/	emit(return_);			// return

	// end of epilogue code

	// length of bytecode is in the emitter's pc variable
	cf.methods[0].code_length = pc;
	
	// must copy code to make it persistent
	cf.methods[0].code = copy_code();

	if (!cf.methods[0].code)
		error("Out of memory");
	// save class file to "Calc.class"
	save_classFile(&cf);
	return 0;
}

