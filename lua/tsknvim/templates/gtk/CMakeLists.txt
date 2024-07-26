cmake_minimum_required(VERSION 3.29.1)
project(
	#{project_name}
	VERSION 1.0
	DESCRIPTION "#{Project Name} GTK Project"
	LANGUAGES C
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE Debug)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)
pkg_check_modules(GMODULE_EXPORT REQUIRED IMPORTED_TARGET gmodule-export-2.0)

find_program(GLIB_COMPILE_RESOURCES NAMES glib-compile-resources REQUIRED)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/#{project_name}.gresource.c
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	COMMAND
		${GLIB_COMPILE_RESOURCES} data/#{project_name}.gresource.xml
		--target=${CMAKE_CURRENT_BINARY_DIR}/#{project_name}.gresource.c
		--sourcedir=data/#{project_name} --generate-source
	VERBATIM
	MAIN_DEPENDENCY data/#{project_name}.gresource.xml
	DEPENDS
		data/#{project_name}/window.ui
		data/#{project_name}/style.css
		data/#{project_name}/icons/hicolor/scalable/apps/com.github.TarekSaeed0.#{project_name}.svg
)

add_custom_target(
	#{project_name}_compile_gresources ALL
	DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/#{project_name}.gresource.c
)

find_program(DESKTOP_FILE_VALIDATE NAMES desktop-file-validate)

if(DESKTOP_FILE_VALIDATE)
	add_custom_command(
		OUTPUT
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{project_name}.desktop.validated
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		COMMAND ${DESKTOP_FILE_VALIDATE}
				data/#{project_name}/applications/com.github.TarekSaeed0.#{project_name}.desktop
		COMMAND
			${CMAKE_COMMAND} -E touch
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{project_name}.desktop.validated
		VERBATIM
		MAIN_DEPENDENCY
			data/#{project_name}/applications/com.github.TarekSaeed0.#{project_name}.desktop
	)

	add_custom_target(
		#{project_name}_validate_desktop_file ALL
		DEPENDS
			${CMAKE_CURRENT_BINARY_DIR}/com.github.TarekSaeed0.#{project_name}.desktop.validated
	)
endif()

add_executable(
	${PROJECT_NAME} ${CMAKE_CURRENT_BINARY_DIR}/#{project_name}.gresource.c
					src/#{project_name}/application.c src/main.c
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

install(TARGETS #{project_name})
install(DIRECTORY data/#{project_name}/icons data/#{project_name}/applications TYPE DATA)
