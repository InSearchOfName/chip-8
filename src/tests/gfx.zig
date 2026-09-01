const std = @import("std");
const gfx = @cImport({
    @cInclude("gfx.h");
});

test "gfx should draw a pixel in the top left corner" {
    gfx.gfx_init();
    gfx.gfx_clear();
    gfx.gfx_draw_pixel(0, 0);
    std.debug.assert(gfx.gfx_get_pixel(0, 0) == 1);
}

test "gfx should be cleared on clear" {
    gfx.gfx_init();
    gfx.gfx_draw_pixel(0, 0);
    gfx.gfx_clear();
    std.debug.assert(gfx.gfx_get_pixel(0, 0) == 0);
}

test "gfx should ignore pixels drawn outside of the drawing grid" {
   gfx.gfx_init();
   gfx.gfx_draw_pixel(800,800);
   
}

