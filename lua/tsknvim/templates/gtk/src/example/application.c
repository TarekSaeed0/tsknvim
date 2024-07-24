#include <example/application.h>
#include <glib.h>

struct _ExampleApplication {
	GtkApplication parent;
};

G_DEFINE_TYPE(ExampleApplication, example_application, GTK_TYPE_APPLICATION)

static void example_application_init(ExampleApplication *application) {
	(void)application;
}

static void remove_style_provider(gpointer data) {
	GtkStyleProvider *provider = GTK_STYLE_PROVIDER(data);
	gtk_style_context_remove_provider_for_display(gdk_display_get_default(), provider);
}

G_MODULE_EXPORT void button_greet_clicked(GtkButton *self, gpointer user_data) {
	(void)self, (void)user_data;

	g_print("Hello, World!\n");
}

static void example_application_activate(GApplication *application) {
	GtkBuilder *builder =
		gtk_builder_new_from_resource("/com/github/TarekSaeed0/example/window.ui");

	GtkWindow *window = GTK_WINDOW(gtk_builder_get_object(builder, "window"));
	gtk_window_set_application(GTK_WINDOW(window), GTK_APPLICATION(application));

	GtkCssProvider *provider = gtk_css_provider_new();
	gtk_css_provider_load_from_resource(provider, "/com/github/TarekSaeed0/example/style.css");
	gtk_style_context_add_provider_for_display(
		gdk_display_get_default(),
		GTK_STYLE_PROVIDER(provider),
		G_MAXUINT
	);
	g_object_set_data_full(
		G_OBJECT(window),
		"provider",
		GTK_STYLE_PROVIDER(provider),
		remove_style_provider
	);

	GtkIconTheme *icon_theme =
		gtk_icon_theme_get_for_display(gtk_widget_get_display(GTK_WIDGET(window)));
	gtk_icon_theme_add_resource_path(icon_theme, "/com/github/TarekSaeed0/example/icons");

	gtk_window_present(GTK_WINDOW(window));

	g_object_unref(builder);
}

static void example_application_class_init(ExampleApplicationClass *class) {
	G_APPLICATION_CLASS(class)->activate = example_application_activate;
}

ExampleApplication *example_application_new(void) {
	return g_object_new(
		EXAMPLE_APPLICATION_TYPE,
		"application-id",
		"com.github.TarekSaeed0.example",
		"flags",
		G_APPLICATION_DEFAULT_FLAGS,
		NULL
	);
}
