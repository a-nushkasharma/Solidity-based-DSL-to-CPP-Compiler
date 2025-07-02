%code requires {
  #include <vector>
  #include <string>
  #include "ast.h"
   
}

%{
#include <iostream>
#include <memory>
#include <string>
#include <vector> 
#include <cstdio>
#include "ast.h"

static_assert(sizeof(std::vector<int>) >= 0, "vector included");
extern int yylex();
extern FILE* yyin;
void yyerror(const char *s) { fprintf(stderr, "Parse error: %s\n", s); }

std::unique_ptr<Contract> contract;
%}

%debug

%union {
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
}

%token <str> IDENTIFIER
%token <num> NUMBER BOOL_LITERAL
%token <str> ADDRESS_LITERAL

%token CONTRACT FUNCTION RETURNS PUBLIC RETURN IF ELSE
%token T_UINT T_INT T_BOOL T_ADDRESS


%token ASSIGN PLUS MINUS MULT DIV MOD
%token EQ NEQ GT LT GE LE
%token AND OR NOT

%token LPAREN RPAREN LBRACE RBRACE COMMA SEMICOLON

%type <type> Type ReturnType
%type <expr> Expression
%type <vardecl> Param Declaration
%type <vardecl_list> ParamList
%type <stmt> Statement
%type <stmt_list> StatementList Block
%type <func> FunctionDef
%type <func_list> FunctionList

%%

Program:
    CONTRACT IDENTIFIER LBRACE FunctionList RBRACE
    {
        contract = std::make_unique<Contract>();
        contract->name = $2;
        contract->functions = std::move(*$4);
        delete $4;
    }
;

FunctionList:
    FunctionList FunctionDef {
        $1->push_back(std::move(*$2));
        delete $2;
        $$ = $1;
    }
    | FunctionDef {
        $$ = new std::vector<Function>();
        $$->push_back(std::move(*$1));
        delete $1;
    }
;

FunctionDef:
    FUNCTION IDENTIFIER LPAREN ParamList RPAREN PUBLIC ReturnType Block {
        $$ = new Function();
        $$->name = $2;
        $$->params = std::move(*$4);
        $$->returnType = $7;
        for (auto* stmt : *$8)
            $$->body.emplace_back(stmt);
        delete $4; delete $8;
    }
;

ParamList:
    ParamList COMMA Param {
        $1->push_back(std::move(*$3));
        delete $3;
        $$ = $1;
    }
    | Param {
        $$ = new std::vector<VarDecl>();
        $$->push_back(std::move(*$1));
        delete $1;
    }
    | /* empty */ { $$ = new std::vector<VarDecl>(); }
;

Param:
    Type IDENTIFIER {
        $$ = new VarDecl{$1, $2, nullptr};
    }
;

ReturnType:
    RETURNS LPAREN Type RPAREN { $$ = $3; }
;

Type:
    T_UINT    { $$ = Type::UINT; }
  | T_INT     { $$ = Type::INT; }
  | T_BOOL    { $$ = Type::BOOL; }
  | T_ADDRESS { $$ = Type::ADDRESS; }
;


Block:
    LBRACE StatementList RBRACE { $$ = $2; }
;

StatementList:
    StatementList Statement {
        $1->push_back($2);
        $$ = $1;
    }
    | /* empty */ {
        $$ = new std::vector<Statement*>();
    }
;

Statement:
    Declaration{
         $$ = new DeclStmt(std::move(*$1));
        delete $1;
    }
    | IDENTIFIER ASSIGN Expression SEMICOLON {
        $$ = new ExprStmt(std::make_unique<BinaryExpr>("=", std::make_unique<VariableExpr>($1), std::unique_ptr<Expression>($3)));
    }
    | IF LPAREN Expression RPAREN Block {
    std::vector<std::unique_ptr<Statement>> thenBody;
    for (auto* stmt : *$5) {
        thenBody.emplace_back(stmt);
    }
    $$ = new IfStmt(std::unique_ptr<Expression>($3), std::move(thenBody), {});
    delete $5;
    }
    | IF LPAREN Expression RPAREN Block ELSE Block {
    std::vector<std::unique_ptr<Statement>> thenBody;
    for (auto* stmt : *$5) {
        thenBody.emplace_back(stmt);
    }
    std::vector<std::unique_ptr<Statement>> elseBody;
    for (auto* stmt : *$7) {
        elseBody.emplace_back(stmt);
    }
    $$ = new IfStmt(std::unique_ptr<Expression>($3), std::move(thenBody), std::move(elseBody));
    delete $5;
    delete $7;
    }

    | RETURN Expression SEMICOLON {
        $$ = new ReturnStmt(std::unique_ptr<Expression>($2));
    }
    | Expression SEMICOLON {
        $$ = new ExprStmt(std::unique_ptr<Expression>($1));
    }
;

Declaration:
    Type IDENTIFIER ASSIGN Expression SEMICOLON {
        $$ = new VarDecl{$1, $2, std::unique_ptr<Expression>($4)};
    }
    | Type IDENTIFIER SEMICOLON {
        $$ = new VarDecl{$1, $2, nullptr};
    }
;


Expression:
    Expression PLUS Expression  { $$ = new BinaryExpr("+", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression MINUS Expression { $$ = new BinaryExpr("-", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression MULT Expression { $$ = new BinaryExpr("*", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression DIV Expression  { $$ = new BinaryExpr("/", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression MOD Expression  { $$ = new BinaryExpr("%", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }

    | Expression EQ Expression   { $$ = new BinaryExpr("==", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression NEQ Expression  { $$ = new BinaryExpr("!=", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression GT Expression   { $$ = new BinaryExpr(">", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression LT Expression   { $$ = new BinaryExpr("<", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression GE Expression   { $$ = new BinaryExpr(">=", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression LE Expression   { $$ = new BinaryExpr("<=", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }

    | Expression AND Expression  { $$ = new BinaryExpr("&&", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }
    | Expression OR Expression   { $$ = new BinaryExpr("||", std::unique_ptr<Expression>($1), std::unique_ptr<Expression>($3)); }

    | NOT Expression             { $$ = new UnaryExpr("!", std::unique_ptr<Expression>($2)); }
    | MINUS Expression           { $$ = new UnaryExpr("-", std::unique_ptr<Expression>($2)); }

    | LPAREN Expression RPAREN   { $$ = $2; }
    | NUMBER                     { $$ = new NumberExpr($1); }
    | BOOL_LITERAL               { $$ = new BoolExpr($1); }
    | ADDRESS_LITERAL            { $$ = new AddressExpr($1); }
    | IDENTIFIER                 { $$ = new VariableExpr($1); }
;

%%

