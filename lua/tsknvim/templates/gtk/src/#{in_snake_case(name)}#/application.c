#include <#{in_snake_case(name)}#/application.h>

#include <#{in_snake_case(name)}#/application_window.h>

struct _#{in_pascal_case(name)}#Application {
	GtkApplication parent;
};

G_DEFINE_TYPE(#{in_pascal_case(name)}#Application, #{in_snake_case(name)}#_application, GTK_TYPE_APPLICATION)

static void #{in_snake_case(name)}#_application_init(#{in_pascal_case(name)}#Application *self) {
	(void)self;
}

static void remove_style_provider(gpointer data) {
	GtkStyleProvider *provider = GTK_STYLE_PROVIDER(data);
	gtk_style_context_remove_provider_for_display(gdk_display_get_default(), provider);
}

static void #{in_snake_case(name)}#_application_activate(GApplication *application) {
	#{in_pascal_case(name)}#ApplicationWindow *window =
		#{in_snake_case(name)}#_application_window_new(#{in_screaming_snake_case(name)}#_APPLICATION(application));

	GtkCssProvider *provider = gtk_css_provider_new();
	gtk_css_provider_load_from_resource(provider, "/com/github/TarekSaeed0/#{in_snake_case(name)}#/style.css");
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
	gtk_icon_theme_add_resource_path(icon_theme, "/com/github/TarekSaeed0/#{in_snake_case(name)}#/icons/hicolor");

	gtk_window_present(GTK_WINDOW(window));
}

static void #{in_snake_case(name)}#_application_class_init(#{in_pascal_case(name)}#ApplicationClass *class) {
	G_APPLICATION_CLASS(class)->activate = #{in_snake_case(name)}#_application_activate;
}

#{in_pascal_case(name)}#Application *#{in_snake_case(name)}#_application_new(void) {
	return g_object_new(
		#{in_screaming_snake_case(name)}#_APPLICATION_TYPE,
		"application-id",
		"com.github.TarekSaeed0.#{in_snake_case(name)}#",
		"flags",
		G_APPLICATION_DEFAULT_FLAGS,
		NULL
	);
}
