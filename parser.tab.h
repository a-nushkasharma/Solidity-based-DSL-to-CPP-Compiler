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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
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
    IDENTIFIER = 258,              /* IDENTIFIER  */
    NUMBER = 259,                  /* NUMBER  */
    BOOL_LITERAL = 260,            /* BOOL_LITERAL  */
    ADDRESS_LITERAL = 261,         /* ADDRESS_LITERAL  */
    CONTRACT = 262,                /* CONTRACT  */
    FUNCTION = 263,                /* FUNCTION  */
    PUBLIC = 264,                  /* PUBLIC  */
    RETURNS = 265,                 /* RETURNS  */
    UINT = 266,                    /* UINT  */
    INT = 267,                     /* INT  */
    BOOL = 268,                    /* BOOL  */
    ADDRESS = 269,                 /* ADDRESS  */
    IF = 270,                      /* IF  */
    ELSE = 271,                    /* ELSE  */
    RETURN = 272,                  /* RETURN  */
    ASSIGN = 273,                  /* ASSIGN  */
    PLUS = 274,                    /* PLUS  */
    MINUS = 275,                   /* MINUS  */
    MULT = 276,                    /* MULT  */
    DIV = 277,                     /* DIV  */
    MOD = 278,                     /* MOD  */
    EQ = 279,                      /* EQ  */
    NEQ = 280,                     /* NEQ  */
    GT = 281,                      /* GT  */
    LT = 282,                      /* LT  */
    GE = 283,                      /* GE  */
    LE = 284,                      /* LE  */
    AND = 285,                     /* AND  */
    OR = 286,                      /* OR  */
    NOT = 287,                     /* NOT  */
    LPAREN = 288,                  /* LPAREN  */
    RPAREN = 289,                  /* RPAREN  */
    LBRACE = 290,                  /* LBRACE  */
    RBRACE = 291,                  /* RBRACE  */
    COMMA = 292,                   /* COMMA  */
    SEMICOLON = 293                /* SEMICOLON  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "parser.y"

    int num;
    char* str;
    Expression* expr;
    VarDecl* vardecl;
    Statement* stmt;
    Type type;
    std::vector<VarDecl>* vardecl_list;
    std::vector<Statement*>* stmt_list;
    Function* func;
    std::vector<Function>* func_list;

#line 115 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
