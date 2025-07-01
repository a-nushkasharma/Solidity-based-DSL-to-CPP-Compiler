// ast.h
#pragma once
#include <memory>
#include <string>
#include <vector>
#include <iostream>

struct Expression {
    virtual ~Expression() = default;
    virtual void generate(std::ostream& out) const = 0;
};

struct NumberExpr : public Expression {
    int value;
    NumberExpr(int val) : value(val) {}
    void generate(std::ostream& out) const override {
        out << value;
    }
};

struct VariableExpr :public Expression {
    std::string name;
    VariableExpr(const std::string& n) : name(n) {}
    void generate(std::ostream& out) const override {
        out << name;
    }
};

struct BinaryExpr : public Expression {
    std::string op;
    std::unique_ptr<Expression> lhs, rhs;
    BinaryExpr(std::string o, std::unique_ptr<Expression> l, std::unique_ptr<Expression> r)
        : op(std::move(o)), lhs(std::move(l)), rhs(std::move(r)) {}
    void generate(std::ostream& out) const override {
        out << "(";
        lhs->generate(out);
        out << " " << op << " ";
        rhs->generate(out);
        out << ")";
    }
};

struct VarDecl {
    std::string name;
    std::unique_ptr<Expression> expr;

    VarDecl(std::string n, std::unique_ptr<Expression> e)
        : name(std::move(n)), expr(std::move(e)) {}

    // Enable move semantics
    VarDecl(VarDecl&&) = default;
    VarDecl& operator=(VarDecl&&) = default;

    // Disable copy semantics
    VarDecl(const VarDecl&) = delete;
    VarDecl& operator=(const VarDecl&) = delete;

    void generate(std::ostream& out) const {
        out << "    unsigned int " << name << " = ";
        expr->generate(out);
        out << ";\n";
    }
};

struct Contract {
    std::string name;
    std::vector<VarDecl> variables;

    void generate(std::ostream& out) const {
    out << "#include <iostream>\n";
     out << "class " << name << " {\n";
    out << "public:\n";

    for (const auto& var : variables) {
        var.generate(out);  // call VarDecl::generate
    }

    out << "};\n\n";
     out << "int main() {\n";
    out << "    " << name << " obj;\n";
    out << "    std::cout << \"result: \" << obj." << variables.back().name << " << std::endl;\n";
    out << "    return 0;\n";
    out << "}\n";
}
};
