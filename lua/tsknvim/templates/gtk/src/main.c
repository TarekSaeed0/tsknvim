#include <gtk/gtk.h>

#include <#{in_snake_case(name)}#/application.h>

int main(int argc, char *argv[]) {
	return g_application_run(G_APPLICATION(#{in_snake_case(name)}#_application_new()), argc, argv);
}
