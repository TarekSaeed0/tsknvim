cmake_minimum_required(VERSION #{vim.version.parse(vim.fn.system({ "cmake", "--version" }))}#)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	LANGUAGES CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

add_executable(#{in_snake_case(name)}# src/main.cpp)
target_compile_options(
	#{in_snake_case(name)}#
	PRIVATE -O2
			-Werror
			-Wall
			-Wextra
			-pedantic
			-Wfloat-equal
			-Wundef
			-Wshadow
			-Wpointer-arith
			-Wcast-align
			-Wstrict-prototypes
			-Wstrict-overflow=5
			-Wwrite-strings
			-Wcast-qual
			-Wconversion
			-Wunreachable-code
)
