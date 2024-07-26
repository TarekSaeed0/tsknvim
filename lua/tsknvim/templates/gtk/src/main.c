#include <gtk/gtk.h>

#include <#{project_name}/application.h>

int main(int argc, char *argv[]) {
	return g_application_run(G_APPLICATION(#{project_name}_application_new()), argc, argv);
}
