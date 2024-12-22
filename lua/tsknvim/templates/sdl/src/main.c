#include <SDL.h>
#include <SDL_image.h>
#include <SDL_keyboard.h>
#include <SDL_render.h>
#include <SDL_surface.h>
#include <SDL_ttf.h>
#include <SDL_video.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

enum {
	APPLICATION_DEFAULT_WINDOW_WIDTH = 512,
	APPLICATION_DEFAULT_WINDOW_HEIGHT = 512,
};

struct application {
	SDL_Renderer *renderer;
	SDL_Window *window;
	SDL_Texture *text_texture;
	SDL_Rect text_rect;
	float delta_time;
};
int application_create(struct application *application) {
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER)) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to initalize SDL: SDL_Error: %s\n",
			SDL_GetError()
		);
		goto no_cleanup;
	}

	if (TTF_Init() == -1) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to initalize SDL_ttf: TTF_Error: %s\n",
			TTF_GetError()
		);
		goto sdl_cleanup;
	}

	application->window = SDL_CreateWindow(
		"Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		APPLICATION_DEFAULT_WINDOW_WIDTH,
		APPLICATION_DEFAULT_WINDOW_HEIGHT,
		0
	);
	if (!application->window) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to create window: SDL_Error: %s\n",
			SDL_GetError()
		);
		goto ttf_cleanup;
	}

	application->renderer = SDL_CreateRenderer(application->window, -1, SDL_RENDERER_ACCELERATED);
	if (!application->renderer) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to create renderer: SDL_Error: %s\n",
			SDL_GetError()
		);
		goto window_cleanup;
	}

	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");

	const char *font_path = "data/arial.ttf";
	TTF_Font *font = TTF_OpenFont(font_path, 64);
	if (!font) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to load font \"%s\": TTF_Error: %s\n",
			font_path,
			TTF_GetError()
		);
		goto renderer_cleanup;
	}

	SDL_Surface *surface =
		TTF_RenderText_Blended_Wrapped(font, "Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!", (SDL_Color){ 0, 0, 0, UINT8_MAX }, 0);
	if (surface == NULL) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to render text: TTF_Error: %s\n",
			TTF_GetError()
		);
		goto font_cleanup;
	}

	application->text_texture = SDL_CreateTextureFromSurface(application->renderer, surface);
	application->text_rect.x = (APPLICATION_DEFAULT_WINDOW_WIDTH - surface->w) / 2;
	application->text_rect.y = (APPLICATION_DEFAULT_WINDOW_HEIGHT - surface->h) / 2;
	application->text_rect.w = surface->w;
	application->text_rect.h = surface->h;

	SDL_FreeSurface(surface);
	TTF_CloseFont(font);

	application->delta_time = 0;

	return EXIT_SUCCESS;
font_cleanup:
	TTF_CloseFont(font);
renderer_cleanup:
	SDL_DestroyRenderer(application->renderer);
window_cleanup:
	SDL_DestroyWindow(application->window);
ttf_cleanup:
	TTF_Quit();
sdl_cleanup:
	SDL_Quit();
no_cleanup:
	return EXIT_FAILURE;
}
void application_destroy(struct application *application) {
	SDL_DestroyTexture(application->text_texture);
	SDL_DestroyRenderer(application->renderer);
	SDL_DestroyWindow(application->window);
	TTF_Quit();
	SDL_Quit();
}
void application_graphics(struct application *application) {
	SDL_SetRenderDrawColor(application->renderer, UINT8_MAX, UINT8_MAX, UINT8_MAX, UINT8_MAX);
	SDL_RenderClear(application->renderer);

	SDL_SetRenderDrawColor(application->renderer, 0, 0, 0, 0);

	SDL_RenderCopy(application->renderer, application->text_texture, NULL, &application->text_rect);

	SDL_RenderPresent(application->renderer);
}
void application_step(struct application *application) {
	Uint64 start_time = SDL_GetTicks64();

	application_graphics(application);

	Uint64 end_time = SDL_GetTicks64();
	if (1000 / 60 > (end_time - start_time)) {
		SDL_Delay(1000 / 60 - (Uint32)(end_time - start_time));
		end_time = SDL_GetTicks64();
	}
	application->delta_time = (float)(end_time - start_time) / 1000;
}
void application_handle_event(struct application *application, SDL_Event *event) {
	(void)application;
	switch (event->type) { default:; }
}
void application_run(struct application *application) {
	while (true) {
		SDL_Event event;
		while (SDL_PollEvent(&event)) {
			if (event.type == SDL_QUIT) {
				return;
			}
			application_handle_event(application, &event);
		}

		application_step(application);
	}
}

int main(int argc, char *argv[]) {
	(void)argc, (void)argv;

	struct application application;
	if (application_create(&application) == EXIT_FAILURE) {
		return EXIT_FAILURE;
	}
	application_run(&application);
	application_destroy(&application);

	return EXIT_SUCCESS;
}
