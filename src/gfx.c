#include <SDL2/SDL.h>
#include <stdlib.h>

#include "gfx.h"

static SDL_Window *window = NULL;
static SDL_Renderer *renderer = NULL;
static uint8_t framebuffer[GFX_WIDTH * GFX_HEIGHT] = {0};

void gfx_init(void) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        SDL_Log("Unable to initialize SDL: %s", SDL_GetError());
        return;
    }

    window = SDL_CreateWindow(
        "Chip-8 Emulator",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        640,
        320,
        SDL_WINDOW_SHOWN
    );
    if (window == NULL) {
        SDL_Log("Unable to create window: %s", SDL_GetError());
        SDL_Quit();
        return;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (renderer == NULL) {
        SDL_Log("Unable to create renderer: %s", SDL_GetError());
        SDL_DestroyWindow(window);
        window = NULL;
        SDL_Quit();
        return;
    }
}

void gfx_clear(void) {
    for (size_t i = 0; i < GFX_WIDTH * GFX_HEIGHT; ++i) {
        framebuffer[i] = 0;
    }

    if (renderer == NULL) {
        return;
    }

    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

void gfx_draw(const uint8_t *pixels, size_t len) {
    if (pixels == NULL || len == 0) {
        return;
    }

    for (size_t i = 0; i < len && i < GFX_WIDTH * GFX_HEIGHT; ++i) {
        framebuffer[i] = pixels[i] ? 1 : 0;
    }

    if (renderer == NULL) {
        return;
    }

    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

void gfx_draw_pixel(int x, int y) {
    if (x < 0 || x >= GFX_WIDTH || y < 0 || y >= GFX_HEIGHT) {
        return;
    }

    framebuffer[(size_t)y * GFX_WIDTH + (size_t)x] = 1;
}

int gfx_get_pixel(int x, int y) {
    if (x < 0 || x >= GFX_WIDTH || y < 0 || y >= GFX_HEIGHT) {
        return 0;
    }

    return framebuffer[(size_t)y * GFX_WIDTH + (size_t)x];
}