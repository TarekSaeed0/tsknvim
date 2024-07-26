#include <#{project_name}/application.h>
#include <glib.h>

struct _#{ProjectName}Application {
	GtkApplication parent;
};

G_DEFINE_TYPE(#{ProjectName}Application, #{project_name}_application, GTK_TYPE_APPLICATION)

static void #{project_name}_application_init(#{ProjectName}Application *application) {
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

static void #{project_name}_application_activate(GApplication *application) {
	GtkBuilder *builder =
		gtk_builder_new_from_resource("/com/github/TarekSaeed0/#{project_name}/window.ui");

	GtkWindow *window = GTK_WINDOW(gtk_builder_get_object(builder, "window"));
	gtk_window_set_application(GTK_WINDOW(window), GTK_APPLICATION(application));

	GtkCssProvider *provider = gtk_css_provider_new();
	gtk_css_provider_load_from_resource(provider, "/com/github/TarekSaeed0/#{project_name}/style.css");
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
	gtk_icon_theme_add_resource_path(icon_theme, "/com/github/TarekSaeed0/#{project_name}/icons");

	gtk_window_present(GTK_WINDOW(window));

	g_object_unref(builder);
}

static void #{project_name}_application_class_init(#{ProjectName}ApplicationClass *class) {
	G_APPLICATION_CLASS(class)->activate = #{project_name}_application_activate;
}

#{ProjectName}Application *#{project_name}_application_new(void) {
	return g_object_new(
		#{PROJECT_NAME}_APPLICATION_TYPE,
		"application-id",
		"com.github.TarekSaeed0.#{project_name}",
		"flags",
		G_APPLICATION_DEFAULT_FLAGS,
		NULL
	);
}
