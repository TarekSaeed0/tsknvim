#ifndef #{PROJECT_NAME}_APPLICATION_H
#define #{PROJECT_NAME}_APPLICATION_H

#include <gtk/gtk.h>

G_BEGIN_DECLS

#define #{PROJECT_NAME}_APPLICATION_TYPE #{project_name}_application_get_type()
G_DECLARE_FINAL_TYPE(#{ProjectName}Application, #{project_name}_application, #{PROJECT_NAME}, APPLICATION, GtkApplication)

#{ProjectName}Application *#{project_name}_application_new(void);

G_END_DECLS

#endif
