cmake_minimum_required(VERSION #{vim.version.parse(vim.fn.system({ "cmake", "--version" }))}#)
project(
	#{in_snake_case(name)}#
	VERSION 1.0
	LANGUAGES C
	DESCRIPTION "#{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}# GTK Project"
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)
pkg_check_modules(GMODULE_EXPORT REQUIRED IMPORTED_TARGET gmodule-export-2.0)

find_program(INKSCAPE NAMES inkscape)
find_program(MAGICK NAMES magick)

if(INKSCAPE AND MAGICK)
	add_custom_command(
		OUTPUT
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.icons.generated
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		COMMAND
			${CMAKE_COMMAND} -E make_directory
			data/#{in_snake_case(name)}#/icons/hicolor/16x16/apps
			data/#{in_snake_case(name)}#/icons/hicolor/32x32/apps
			data/#{in_snake_case(name)}#/icons/hicolor/48x48/apps
		COMMAND
			${INKSCAPE} -w 16 -h 16 -o
			data/#{in_snake_case(name)}#/icons/hicolor/16x16/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
		COMMAND
			${INKSCAPE} -w 32 -h 32 -o
			data/#{in_snake_case(name)}#/icons/hicolor/32x32/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
		COMMAND
			${INKSCAPE} -w 48 -h 48 -o
			data/#{in_snake_case(name)}#/icons/hicolor/48x48/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
		COMMAND
			${MAGICK}
			data/#{in_snake_case(name)}#/icons/hicolor/16x16/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/hicolor/32x32/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/hicolor/48x48/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.png
			data/#{in_snake_case(name)}#/icons/com.github.TarekSaeed0.#{in_snake_case(name)}#.ico
		COMMAND
			${CMAKE_COMMAND} -E touch
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.icons.generated
		VERBATIM
		MAIN_DEPENDENCY
			data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
	)
else()
	add_custom_command(
		OUTPUT
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.icons.generated
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		COMMAND
			${CMAKE_COMMAND} -E touch
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.icons.generated
		VERBATIM
		MAIN_DEPENDENCY
			data/#{in_snake_case(name)}#/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{in_snake_case(name)}#.svg
	)
endif()

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
		data/#{in_snake_case(name)}#/ui/window.ui
		data/#{in_snake_case(name)}#/style.css
		${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{in_snake_case(name)}#.icons.generated
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
		COMMAND
			${DESKTOP_FILE_VALIDATE}
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
	#{in_snake_case(name)}#
	${CMAKE_CURRENT_BINARY_DIR}/#{in_snake_case(name)}#.gresource.c
	src/#{in_snake_case(name)}#/application.c
	src/main.c
)
target_sources(
	#{in_snake_case(name)}#
	PRIVATE
		data/#{in_snake_case(name)}#/icons/com.github.TarekSaeed0.#{in_snake_case(name)}#.rc
)
target_include_directories(${PROJECT_NAME} PRIVATE include)
target_link_libraries(
	#{in_snake_case(name)}# PRIVATE PkgConfig::GTK4 PkgConfig::GMODULE_EXPORT
)
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
			-Wno-overlength-strings
)
if(WIN32)
	target_compile_options(#{in_snake_case(name)}# PRIVATE -mwindows)
	target_link_options(#{in_snake_case(name)}# PRIVATE -Wl,-subsystem,console)
endif()

install(TARGETS #{in_snake_case(name)}#)
install(DIRECTORY data/#{in_snake_case(name)}#/icons
				  data/#{in_snake_case(name)}#/applications TYPE DATA
)
