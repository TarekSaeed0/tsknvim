cmake_minimum_required(VERSION 3.29.1)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	DESCRIPTION "#{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}# GTK Project"
	LANGUAGES C
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)
pkg_check_modules(GMODULE_EXPORT REQUIRED IMPORTED_TARGET gmodule-export-2.0)

find_program(GLIB_COMPILE_RESOURCES NAMES glib-compile-resources REQUIRED)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/#{in_snake_case(name)}#.gresource.c
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	COMMAND
		${GLIB_COMPILE_RESOURCES} data/#{in_snake_case(name)}#.gresource.xml
		--target=${CMAKE_CURRENT_BINARY_DIR}/#{in_snake_case(name)}#.gresource.c
		--sourcedir=data/#{in_snake_case(name)}# --generate-source
	VERBATIM
	MAIN_DEPENDENCY data/#{in_snake_case(name)}#.gresource.xml
	DEPENDS
		data/#{in_snake_case(name)}#/window.ui
		data/#{in_snake_case(name)}#/style.css
		data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
)

add_custom_target(
	#{in_snake_case(name)}#_compile_gresources ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/#{in_snake_case(name)}#.gresource.c
)

find_program(DESKTOP_FILE_VALIDATE NAMES desktop-file-validate)

if(DESKTOP_FILE_VALIDATE)
	add_custom_command(
		OUTPUT
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.desktop.validated
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		COMMAND ${DESKTOP_FILE_VALIDATE}
				data/#{in_snake_case(name)}#/applications/com.github.TarekSaeed0.#{in_snake_case(name)}#.desktop
		COMMAND
			${CMAKE_COMMAND} -E touch
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.desktop.validated
		VERBATIM
		MAIN_DEPENDENCY
			data/#{in_snake_case(name)}#/applications/com.github.TarekSaeed0.#{in_snake_case(name)}#.desktop
	)

	add_custom_target(
		#{in_snake_case(name)}#_validate_desktop_file ALL
		DEPENDS
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.desktop.validated
	)
endif()

add_executable(
	${PROJECT_NAME} ${CMAKE_CURRENT_BINARY_DIR}/#{in_snake_case(name)}#.gresource.c
					src/#{in_snake_case(name)}#/application.c src/main.c
)
target_include_directories(${PROJECT_NAME} PRIVATE include)
target_link_libraries(
	${PROJECT_NAME} PRIVATE PkgConfig::GTK4 PkgConfig::GMODULE_EXPORT
)
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
			-Wswitch-enum
			-Wconversion
			-Wunreachable-code
			-Wno-overlength-strings
)

install(TARGETS #{in_snake_case(name)}#)
install(DIRECTORY data/#{in_snake_case(name)}#/icons data/#{in_snake_case(name)}#/applications TYPE DATA)
