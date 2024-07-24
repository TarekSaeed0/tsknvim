#include <gtk/gtk.h>

#include <example/application.h>

int main(int argc, char *argv[]) {
	return g_application_run(G_APPLICATION(example_application_new()), argc, argv);
}
