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

#ifndef YY_YY_LAB02_TAB_H_INCLUDED
# define YY_YY_LAB02_TAB_H_INCLUDED
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
    CREATE_TABLE = 258,            /* CREATE_TABLE  */
    DROP_TABLE = 259,              /* DROP_TABLE  */
    INSERT = 260,                  /* INSERT  */
    INTO = 261,                    /* INTO  */
    VALUES = 262,                  /* VALUES  */
    DELETE = 263,                  /* DELETE  */
    FROM = 264,                    /* FROM  */
    UPDATE = 265,                  /* UPDATE  */
    SET = 266,                     /* SET  */
    SELECT = 267,                  /* SELECT  */
    WHERE = 268,                   /* WHERE  */
    GROUP_BY = 269,                /* GROUP_BY  */
    ORDER_BY = 270,                /* ORDER_BY  */
    ASC = 271,                     /* ASC  */
    DESC = 272,                    /* DESC  */
    AND = 273,                     /* AND  */
    OR = 274,                      /* OR  */
    MAX = 275,                     /* MAX  */
    MIN = 276,                     /* MIN  */
    AVG = 277,                     /* AVG  */
    COUNT = 278,                   /* COUNT  */
    VARCHAR = 279,                 /* VARCHAR  */
    ENTERO = 280,                  /* ENTERO  */
    DECIMAL = 281,                 /* DECIMAL  */
    CONST_CADENA = 282,            /* CONST_CADENA  */
    IDENTIFICADOR = 283,           /* IDENTIFICADOR  */
    LLAVE_A = 284,                 /* LLAVE_A  */
    LLAVE_C = 285,                 /* LLAVE_C  */
    PARENTESIS_A = 286,            /* PARENTESIS_A  */
    PARENTESIS_C = 287,            /* PARENTESIS_C  */
    CHAR_COMA = 288,               /* CHAR_COMA  */
    CHAR_PUNTOYCOMA = 289,         /* CHAR_PUNTOYCOMA  */
    CHAR_ASTERISCO = 290,          /* CHAR_ASTERISCO  */
    OP_IGUAL = 291,                /* OP_IGUAL  */
    OP_COMP_IGUAL = 292,           /* OP_COMP_IGUAL  */
    OP_DISTINTO = 293,             /* OP_DISTINTO  */
    OP_MENORIGUAL = 294,           /* OP_MENORIGUAL  */
    OP_MAYORIGUAL = 295,           /* OP_MAYORIGUAL  */
    OP_MENOR = 296,                /* OP_MENOR  */
    OP_MAYOR = 297,                /* OP_MAYOR  */
    OP_NEGACION = 298,             /* OP_NEGACION  */
    OP_SUMA = 299,                 /* OP_SUMA  */
    OP_DIV = 300,                  /* OP_DIV  */
    OP_RESTA = 301,                /* OP_RESTA  */
    INTEGER = 302                  /* INTEGER  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_LAB02_TAB_H_INCLUDED  */
