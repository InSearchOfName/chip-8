#ifndef GFX_H
#define GFX_H

#include <stddef.h>
#include <stdint.h>

#define GFX_WIDTH 64
#define GFX_HEIGHT 32

void gfx_init(void);
void gfx_clear(void);
void gfx_draw(const uint8_t *pixels, size_t len);
void gfx_draw_pixel(int x, int y);
int gfx_get_pixel(int x, int y);

#endif // GFX_H