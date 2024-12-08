#ifndef #{in_screaming_snake_case(name)}#_APPLICATION_WINDOW_H
#define #{in_screaming_snake_case(name)}#_APPLICATION_WINDOW_H

#include <#{in_snake_case(name)}#/application.h>
#include <gtk/gtk.h>

G_BEGIN_DECLS

#define #{in_screaming_snake_case(name)}#_APPLICATION_WINDOW_TYPE #{in_snake_case(name)}#_application_window_get_type()
G_DECLARE_FINAL_TYPE(
	#{in_pascal_case(name)}#ApplicationWindow,
	#{in_snake_case(name)}#_application_window,
	#{in_screaming_snake_case(name)}#,
	APPLICATION_WINDOW,
	GtkApplicationWindow
)

#{in_pascal_case(name)}#ApplicationWindow *#{in_snake_case(name)}#_application_window_new(#{in_pascal_case(name)}#Application *application);

G_END_DECLS

#endif
