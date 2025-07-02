# Solidity based DSL to CPP Compiler 

A tool that converts simplified smart contracts written in a SOlidity based Domain-Specific Language (DSL) into equivalent C++ code.

## Project Overview

This compiler parses and semantically analyzes a Solidity-like language and generates equivalent C++ source code. 

It supports:

- **Primitive types**: `uint`, `int`, `bool`, `address`
- **Function declarations** with parameters and return types
- **Arithmetic**, **logical**, and **comparison** operators
- **Control flow constructs**: `if`, `else`, and `return`
- **Static typing** and **basic type checking**
- Generation of **clean, readable, and valid C++**

---
## Directory Structure
```bash
dsl-compiler/
├── build/ #contains the build files                
│   ├── ouput.cpp        #final CPP file
│   └── ...
├── test/                #.dsl files
│   └── contract.dsl     #input file with DSL
|   └── test_cases.dsl   #sample test cases supported by the Compiler
├── parser.y             # Bison grammar rules
├── scanner.l            # Flex token definitions
├── main.cpp             # Compiler driver
├── CMakeLists.txt       # CMake build configuration
├──ast.h                 # Abstract syntax tree node definitions
└── README.md
```
---
## System Requirements

To build and run the DSL-to-C++ compiler, the following tools are required:

| Tool            | Version      | Description                                 |
|-----------------|--------------|---------------------------------------------|
| **C++ Compiler**| C++17 or newer | Required to compile the generated C++ code |
| **Flex**        | ≥ 2.6.4      | Lexical analyzer (tokenizer) generator      |
| **Bison**       | ≥ 3.0        | Parser generator (LALR grammar support)     |
| **CMake**       | ≥ 3.10       | Cross-platform build system generator       |
---
# Build Instructions
```bash
git clone https://github.com/a-nushkasharma/DSLtoCPPCompiler.git
cd (to the file)
```
Incase one wishes to remove the existing build:
```bash
rm -rf build
```
To build:
```bash
mkdir build 
cd build
cmake .. -G "MinGW Makefiles"
mingw32-make clean
mingw32-make
```

#Using the Compiler
After building the project:
```bash
./dsl_compiler ../input.dsl > output.cpp
```
To compile the generated C++:
```bash
g++ -std=c++17 -o program output.cpp
./program
`
``
