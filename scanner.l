%option yylineno

%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include "ast.h"
#include "parser.hpp"
using namespace std;

#ifdef _WIN32
#define strdup _strdup
#endif
%}

%%

"contract"        { return CONTRACT; }
"function"        { return FUNCTION; }
"public"          { return PUBLIC; }
"returns"         { return RETURNS; }

"uint"      { return T_UINT; }
"int"       { return T_INT; }
"bool"      { return T_BOOL; }
"address"   { return T_ADDRESS; }

"if"              { return IF; }
"else"            { return ELSE; }
"return"          { return RETURN; }

"true"            { yylval.num = 1; return BOOL_LITERAL; }
"false"           { yylval.num = 0; return BOOL_LITERAL; }

"0x"[a-fA-F0-9]+  { yylval.str = strdup(yytext); return ADDRESS_LITERAL; }
"=="              { return EQ; }
"!="              { return NEQ; }
">="              { return GE; }
"<="              { return LE; }
">"               { return GT; }
"<"               { return LT; }

"&&"              { return AND; }
"||"              { return OR; }
"!"               { return NOT; }

"+"               { return PLUS; }
"-"               { return MINUS; }
"*"               { return MULT; }
"/"               { return DIV; }
"%"               { return MOD; }

"="               { return ASSIGN; }

"("               { return LPAREN; }
")"               { return RPAREN; }
"{"               { return LBRACE; }
"}"               { return RBRACE; }
","               { return COMMA; }
";"               { return SEMICOLON; }

[0-9]+            { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t\r\n]+        ;
"//".*            ;
.                 { fprintf(stderr, "Unknown character: '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}
