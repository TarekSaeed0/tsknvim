cmake_minimum_required(VERSION #{vim.version.parse(vim.fn.system({ "cmake", "--version" }))}#)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	LANGUAGES C
	DESCRIPTION "#{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}# SDL Project"
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(SDL2 REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)
if(WIN32)
	target_link_libraries(
		app PRIVATE tsk SDL2::SDL2main SDL2::SDL2-static
					SDL2_image::SDL2_image-static SDL2_ttf::SDL2_ttf-static
	)
else()
	target_link_libraries(
		app PRIVATE tsk SDL2::SDL2 SDL2_image::SDL2_image SDL2_ttf::SDL2_ttf
	)
endif()

add_executable(#{in_snake_case(name)}# src/main.c)
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
			-fsanitize=address
)
target_link_options(#{in_snake_case(name)}# PRIVATE -fsanitize=address)

if(WIN32)
	target_compile_options(#{in_snake_case(name)}# PRIVATE -mwindows)
	target_link_options(#{in_snake_case(name)}# PRIVATE -Wl,-subsystem,console)
endif()
