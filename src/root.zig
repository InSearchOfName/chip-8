const test_mod = @import("tests/test.zig");
const test_gfx = @import("tests/gfx.zig");

test {
    _ = test_mod;
    _ = test_gfx;
}