#ifndef EXAMPLE_APPLICATION_H
#define EXAMPLE_APPLICATION_H

#include <gtk/gtk.h>

G_BEGIN_DECLS

#define EXAMPLE_APPLICATION_TYPE example_application_get_type()
G_DECLARE_FINAL_TYPE(ExampleApplication, example_application, EXAMPLE, APPLICATION, GtkApplication)

ExampleApplication *example_application_new(void);

G_END_DECLS

#endif
