#include <#{in_snake_case(name)}#/application_window.h>

struct _#{in_pascal_case(name)}#ApplicationWindow {
	GtkApplicationWindow parent;
	GtkButton *greet_button;
};

G_DEFINE_TYPE(#{in_pascal_case(name)}#ApplicationWindow, #{in_snake_case(name)}#_application_window, GTK_TYPE_APPLICATION_WINDOW)

static void #{in_snake_case(name)}#_application_window_dispose(GObject *gobject) {
	gtk_widget_dispose_template(GTK_WIDGET(gobject), #{in_screaming_snake_case(name)}#_APPLICATION_WINDOW_TYPE);

	G_OBJECT_CLASS(#{in_snake_case(name)}#_application_window_parent_class)->dispose(gobject);
}

static void #{in_snake_case(name)}#_application_window_class_init(#{in_pascal_case(name)}#ApplicationWindowClass *class) {
	G_OBJECT_CLASS(class)->dispose = #{in_snake_case(name)}#_application_window_dispose;

	GtkWidgetClass *widget_class = GTK_WIDGET_CLASS(class);

	gtk_widget_class_set_template_from_resource(
		widget_class,
		"/com/github/TarekSaeed0/#{in_snake_case(name)}#/ui/application_window.ui"
	);

	gtk_widget_class_bind_template_child(widget_class, #{in_pascal_case(name)}#ApplicationWindow, greet_button);
}

static void #{in_snake_case(name)}#_application_window_init(#{in_pascal_case(name)}#ApplicationWindow *self) {
	gtk_widget_init_template(GTK_WIDGET(self));
}

#{in_pascal_case(name)}#ApplicationWindow *#{in_snake_case(name)}#_application_window_new(#{in_pascal_case(name)}#Application *application) {
	return g_object_new(#{in_screaming_snake_case(name)}#_APPLICATION_WINDOW_TYPE, "application", application, NULL);
}

G_MODULE_EXPORT void greet_button_clicked(GtkButton *self, gpointer user_data) {
	(void)self, (void)user_data;

	g_print("Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n");
}
