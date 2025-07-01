#include <fstream>
#include "generator/codegen.hpp"

extern int yyparse();
extern FILE* yyin;
extern ContractNode* root;

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input.dsl\n", argv[0]);
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

    std::ofstream out("output.cpp");
    CodeGenerator generator(out);
    generator.generate(root);

    return 0;
}
