%{
#include <iostream>
#include <memory>
#include <string>
#include <vector>
#include "ast.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char *s) { fprintf(stderr, "Parse error: %s\n", s); }

std::unique_ptr<Contract> contract;
%}

%union {
    int num;
    char* str;
    Expression* expr;
    VarDecl* vardecl;
    std::vector<VarDecl>* vardecl_list;
}

%token CONTRACT UINT
%token <str> IDENTIFIER
%token <num> NUMBER

%token ASSIGN PLUS MINUS MULT DIV
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON

%type <expr> Expression
%type <vardecl> Declaration
%type <vardecl_list> Declarations

%%

Program:
    CONTRACT IDENTIFIER LBRACE Declarations RBRACE
    {
        contract = std::make_unique<Contract>();
        contract->name = $2;
        contract->variables = std::move(*$4);
        delete $4;
    }
;

Declarations:
    Declarations Declaration {
        $1->push_back(std::move(*$2));
        delete $2;
        $$ = $1;
    }
    | Declaration {
        $$ = new std::vector<VarDecl>();
        $$->push_back(std::move(*$1));
        delete $1;
    }
;

Declaration:
    UINT IDENTIFIER ASSIGN Expression SEMICOLON {
        $$ = new VarDecl{$2, std::unique_ptr<Expression>($4)};
    }
;

Expression:
    Expression PLUS Expression {
        $$ = new BinaryExpr("+", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3));
    }
    | Expression MINUS Expression {
        $$ = new BinaryExpr("-", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3));
    }
    | Expression MULT Expression {
        $$ = new BinaryExpr("*", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3));
    }
    | Expression DIV Expression {
        $$ = new BinaryExpr("/", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3));
    }
    | LPAREN Expression RPAREN {
        $$ = $2;
    }
    | NUMBER {
        $$ = new NumberExpr($1);
    }
    | IDENTIFIER {
        $$ = new VariableExpr($1);
    }
;

%%

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: %s <file.dsl>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Cannot open file");
        return 1;
    }

    yyparse();
    fclose(yyin);

    if (contract) {
        contract->generate(std::cout);  // Output C++ code
    }

    return 0;
}
