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
	SDL_Texture *background_texture;
	struct {
		SDL_Texture *texture;
		int width;
		int height;
	} text;
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

	int flags = IMG_INIT_PNG;
	if (!((unsigned)IMG_Init(flags) & (unsigned)flags)) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to initalize SDL_image: IMG_Error: %s\n",
			IMG_GetError()
		);
		goto sdl_cleanup;
	}

	if (TTF_Init() == -1) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to initalize SDL_ttf: TTF_Error: %s\n",
			TTF_GetError()
		);
		goto img_cleanup;
	}

	application->window = SDL_CreateWindow(
		"Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!",
		SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED,
		APPLICATION_DEFAULT_WINDOW_WIDTH,
		APPLICATION_DEFAULT_WINDOW_HEIGHT,
		SDL_WINDOW_RESIZABLE
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

	const char *background_texture_path = "data/speech_bubble.png";
	application->background_texture =
		IMG_LoadTexture(application->renderer, background_texture_path);
	if (!application->background_texture) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to load image \"%s\": IMG_Error: %s\n",
			background_texture_path,
			IMG_GetError()
		);
		goto renderer_cleanup;
	}

	const char *font_path = "data/arial.ttf";
	TTF_Font *font = TTF_OpenFont(font_path, 64);
	if (!font) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to load font \"%s\": TTF_Error: %s\n",
			font_path,
			TTF_GetError()
		);
		goto texture_cleanup;
	}

	SDL_Surface *surface = TTF_RenderText_Blended_Wrapped(
		font,
		"Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!",
		(SDL_Color){ 0, 0, 0, UINT8_MAX },
		0
	);
	if (surface == NULL) {
		SDL_LogError(
			SDL_LOG_CATEGORY_VIDEO,
			"failed to render text: TTF_Error: %s\n",
			TTF_GetError()
		);
		goto font_cleanup;
	}

	application->text.texture = SDL_CreateTextureFromSurface(application->renderer, surface);
	application->text.width = surface->w;
	application->text.height = surface->h;

	SDL_FreeSurface(surface);
	TTF_CloseFont(font);

	return EXIT_SUCCESS;
font_cleanup:
	TTF_CloseFont(font);
texture_cleanup:
	SDL_DestroyTexture(application->background_texture);
renderer_cleanup:
	SDL_DestroyRenderer(application->renderer);
window_cleanup:
	SDL_DestroyWindow(application->window);
ttf_cleanup:
	TTF_Quit();
img_cleanup:
	IMG_Quit();
sdl_cleanup:
	SDL_Quit();
no_cleanup:
	return EXIT_FAILURE;
}
void application_destroy(struct application *application) {
	SDL_DestroyTexture(application->text.texture);
	SDL_DestroyTexture(application->background_texture);
	SDL_DestroyRenderer(application->renderer);
	SDL_DestroyWindow(application->window);
	TTF_Quit();
	IMG_Quit();
	SDL_Quit();
}
void application_run(struct application *application) {
	while (true) {
		SDL_Event event;
		while (SDL_PollEvent(&event)) {
			if (event.type == SDL_QUIT) {
				return;
			}
		}

		SDL_SetRenderDrawColor(application->renderer, UINT8_MAX, UINT8_MAX, UINT8_MAX, UINT8_MAX);
		SDL_RenderClear(application->renderer);

		SDL_SetRenderDrawColor(application->renderer, 0, 0, 0, 0);

		int window_width = 0;
		int window_height = 0;
		SDL_GetWindowSize(application->window, &window_width, &window_height);

		SDL_RenderCopy(
			application->renderer,
			application->background_texture,
			NULL,
			&(struct SDL_Rect){ .w = window_width, .h = window_height }
		);

		SDL_FRect text_rect = {
			.w = (float)application->text.width,
			.h = (float)application->text.height,
		};

		enum {
			TEXTURE_PADDING_X = 70,
			TEXTURE_PADDING_Y = 20,
		};
		if (text_rect.w + 2 * TEXTURE_PADDING_X > (float)window_width) {
			text_rect.w = (float)window_width - 2 * TEXTURE_PADDING_X;
			text_rect.h *= text_rect.w / (float)application->text.width;
		}

		if (text_rect.h + 2 * TEXTURE_PADDING_Y > (float)window_height) {
			text_rect.h = (float)window_height - 2 * TEXTURE_PADDING_Y;
			text_rect.w *= text_rect.h / (float)application->text.height;
		}

		text_rect.x = ((float)window_width - text_rect.w) / 2;
		text_rect.y = ((float)window_height - text_rect.h) / 2;

		SDL_RenderCopyF(application->renderer, application->text.texture, NULL, &text_rect);

		SDL_RenderPresent(application->renderer);
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
