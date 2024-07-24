cmake_minimum_required(VERSION 3.29.1)
project(
	example
	VERSION 1.0
	DESCRIPTION "Example GTK Project"
	LANGUAGES C
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)
pkg_check_modules(GMODULE_EXPORT REQUIRED IMPORTED_TARGET gmodule-export-2.0)

find_program(GLIB_COMPILE_RESOURCES NAMES glib-compile-resources REQUIRED)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/example.gresource.c
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	COMMAND
		${GLIB_COMPILE_RESOURCES} data/example.gresource.xml
		--target=${CMAKE_CURRENT_BINARY_DIR}/example.gresource.c
		--sourcedir=data/example --generate-source
	VERBATIM
	MAIN_DEPENDENCY data/example.gresource.xml
	DEPENDS
		data/example/window.ui
		data/example/style.css
		data/example/icons/hicolor/scalable/apps/com.github.TarekSaeed0.example.svg
)

add_custom_target(
	example_compile_gresources ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/example.gresource.c
)

find_program(DESKTOP_FILE_VALIDATE NAMES desktop-file-validate)

if(DESKTOP_FILE_VALIDATE)
	add_custom_command(
		OUTPUT
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.example.desktop.validated
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		COMMAND ${DESKTOP_FILE_VALIDATE}
				data/example/applications/com.github.TarekSaeed0.example.desktop
		COMMAND
			${CMAKE_COMMAND} -E touch
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.example.desktop.validated
		VERBATIM
		MAIN_DEPENDENCY
			data/example/applications/com.github.TarekSaeed0.example.desktop
	)

	add_custom_target(
		example_validate_desktop_file ALL
		DEPENDS
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.example.desktop.validated
	)
endif()

add_executable(
	${PROJECT_NAME} ${CMAKE_CURRENT_BINARY_DIR}/example.gresource.c
					src/example/application.c src/main.c
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

install(TARGETS example)
install(DIRECTORY data/example/icons data/example/applications TYPE DATA)
