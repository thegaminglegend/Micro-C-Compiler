/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_MYCC_H_INCLUDED
# define YY_YY_MYCC_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    INT8 = 259,                    /* INT8  */
    INT16 = 260,                   /* INT16  */
    INT32 = 261,                   /* INT32  */
    FLT = 262,                     /* FLT  */
    STR = 263,                     /* STR  */
    BREAK = 264,                   /* BREAK  */
    DO = 265,                      /* DO  */
    ELSE = 266,                    /* ELSE  */
    FOR = 267,                     /* FOR  */
    IF = 268,                      /* IF  */
    RETURN = 269,                  /* RETURN  */
    WHILE = 270,                   /* WHILE  */
    PA = 271,                      /* PA  */
    NA = 272,                      /* NA  */
    TA = 273,                      /* TA  */
    DA = 274,                      /* DA  */
    MA = 275,                      /* MA  */
    AA = 276,                      /* AA  */
    XA = 277,                      /* XA  */
    OA = 278,                      /* OA  */
    LA = 279,                      /* LA  */
    RA = 280,                      /* RA  */
    OR = 281,                      /* OR  */
    AN = 282,                      /* AN  */
    EQ = 283,                      /* EQ  */
    NE = 284,                      /* NE  */
    LE = 285,                      /* LE  */
    GE = 286,                      /* GE  */
    LS = 287,                      /* LS  */
    RS = 288,                      /* RS  */
    AR = 289,                      /* AR  */
    PP = 290,                      /* PP  */
    NN = 291                       /* NN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define ID 258
#define INT8 259
#define INT16 260
#define INT32 261
#define FLT 262
#define STR 263
#define BREAK 264
#define DO 265
#define ELSE 266
#define FOR 267
#define IF 268
#define RETURN 269
#define WHILE 270
#define PA 271
#define NA 272
#define TA 273
#define DA 274
#define MA 275
#define AA 276
#define XA 277
#define OA 278
#define LA 279
#define RA 280
#define OR 281
#define AN 282
#define EQ 283
#define NE 284
#define LE 285
#define GE 286
#define LS 287
#define RS 288
#define AR 289
#define PP 290
#define NN 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "mycc.y"
 Symbol *sym;  /* token value yylval.sym is the symbol table entry of an ID */
  unsigned num; /* token value yylval.num is the value of an int constant */
  float flt;    /* token value yylval.flt is the value of a float constant */
  char *str;    /* token value yylval.str is the value of a string constant */
  unsigned loc; /* location of instruction to backpatch */

#line 146 "mycc.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_MYCC_H_INCLUDED  */
