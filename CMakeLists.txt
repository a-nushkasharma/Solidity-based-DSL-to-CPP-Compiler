cmake_minimum_required(VERSION 3.15)
project(DSLToCpp)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

BISON_TARGET(Parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.hpp)
FLEX_TARGET(Scanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp)
ADD_FLEX_BISON_DEPENDENCY(Scanner Parser)

include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(dslc ${FLEX_Scanner_OUTPUTS} ${BISON_Parser_OUTPUTS})
target_include_directories(dslc PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
