const std = @import("std");
const c = @cImport({
    @cInclude("gfx.h");
});

pub fn main() !void {
    c.gfx_init();
    c.gfx_clear();
    std.debug.print("CHIP-8 emulator started\n", .{});
}
