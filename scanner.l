%{
#include <string>
#include <cstdlib>
#include <cstring>
using namespace std;
#include "ast.h"
#include "parser.hpp"
%}

%x COMMENT

%%

"contract"        { return CONTRACT; }
"uint"            { return UINT; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return IDENTIFIER; }

[0-9]+           { yylval.num = atoi(yytext); return NUMBER; }

"="              { return ASSIGN; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MULT; }
"/"              { return DIV; }

"("              { return LPAREN; }
")"              { return RPAREN; }
"{"              { return LBRACE; }
"}"              { return RBRACE; }
";"              { return SEMICOLON; }

[ \t\r\n]+       ;     // Ignore whitespace
"//".*           ;     // Ignore single-line comments
.                { printf("Unknown character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}