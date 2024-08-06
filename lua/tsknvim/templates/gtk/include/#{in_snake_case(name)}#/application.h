#ifndef #{in_screaming_snake_case(name)}#_APPLICATION_H
#define #{in_screaming_snake_case(name)}#_APPLICATION_H

#include <gtk/gtk.h>

G_BEGIN_DECLS

#define #{in_screaming_snake_case(name)}#_APPLICATION_TYPE #{in_snake_case(name)}#_application_get_type()
G_DECLARE_FINAL_TYPE(#{in_pascal_case(name)}#Application, #{in_snake_case(name)}#_application, #{in_screaming_snake_case(name)}#, APPLICATION, GtkApplication)

#{in_pascal_case(name)}#Application *#{in_snake_case(name)}#_application_new(void);

G_END_DECLS

#endif
