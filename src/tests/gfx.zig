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