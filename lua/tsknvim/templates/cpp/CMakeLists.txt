cmake_minimum_required(VERSION #{vim.version.parse(vim.fn.system({ "cmake", "--version" }))}#)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	LANGUAGES CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

add_executable(${PROJECT_NAME} src/main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE header)
target_link_directories(${PROJECT_NAME} PRIVATE library)
target_compile_options(
	${PROJECT_NAME}
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
			-Wswitch-default
			-Wconversion
			-Wunreachable-code
)
