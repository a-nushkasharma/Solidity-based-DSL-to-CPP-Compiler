#include <fstream>
#include <iostream>
extern int yydebug;
#include "ast.h"

extern int yyparse();
extern FILE* yyin;
extern std::unique_ptr<Contract> contract; 

int main(int argc, char** argv) {
    yydebug = 1; 
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " input.dsl\n";
        return 1;
    }

    FILE* file = fopen(argv[1], "r");
    if (!file) {
        perror("fopen");
        return 1;
    }

    yyin = file;
    yyparse();
    fclose(file);

    if (!contract) {
        std::cerr << "No contract parsed.\n";
        return 1;
    }

    std::ofstream out("output.cpp");
    contract->generate(out);

    return 0;
}
