cmake_minimum_required(VERSION #{vim.version.parse(vim.fn.system({ "cmake", "--version" }))}#)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	LANGUAGES C
	DESCRIPTION "A library written in c"
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(#{in_snake_case(name)}# src/#{in_snake_case(name)}#.c src/main.c)
target_include_directories(#{in_snake_case(name)}# PRIVATE include)
target_compile_options(
	#{in_snake_case(name)}#
	PRIVATE -Werror
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
)
