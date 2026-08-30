const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const chip8_translate = b.addTranslateC(.{
        .root_source_file = b.path("src/chip8.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    const chip8_module = chip8_translate.createModule();

    const chip8_lib = b.addLibrary(.{
        .name = "chip8",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    chip8_lib.root_module.linkSystemLibrary("SDL2", .{});
    chip8_lib.root_module.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{
            "chip8.c",
            "gfx.c",
        },
        .flags = &.{
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Werror",
        },
    });
    chip8_lib.root_module.addIncludePath(b.path("src"));

    const app = b.addExecutable(.{
        .name = "chip8",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .imports = &.{
                .{ .name = "chip8", .module = chip8_module },
            },
        }),
    });
    app.root_module.addIncludePath(b.path("src"));
    app.root_module.linkSystemLibrary("SDL2", .{});
    app.root_module.linkLibrary(chip8_lib);
    b.installArtifact(app);

    const run_cmd = b.addRunArtifact(app);
    const run_step = b.step("run", "Run CHIP-8 app");
    run_step.dependOn(&run_cmd.step);

    const chip8_root = b.addModule("chip8", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "chip8", .module = chip8_module },
        },
    });
    chip8_root.addIncludePath(b.path("src"));

    const test_step = b.step("test", "Run tests");
    const tests = b.addTest(.{ .root_module = chip8_root });
    tests.root_module.linkSystemLibrary("SDL2", .{});
    tests.root_module.linkLibrary(chip8_lib);
    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);
}
