const std = @import("std");
const raylib_build = @import("libs/raylib/src/build.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Attempt to add Raylib, handling the potential error locally
    const raylib_result = raylib_build.addRaylib(b, target, optimize, .{});
    const raylib = raylib_result catch |err| {
        std.debug.print("Failed to add Raylib: {}\n", .{err});
        return; // Abort the build function if an error occurs
    };

    const exe = raylib.addRaylib();
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Setting up unit tests
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
