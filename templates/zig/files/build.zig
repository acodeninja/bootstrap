const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("{{PROJECT_SNAKE}}", .{
        .root_source_file = b.path("src/{{PROJECT_SNAKE}}.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(b.addLibrary(.{
        .name = "{{PROJECT_SNAKE}}",
        .root_module = mod,
    }));

    const test_step = b.step("test", "Run the test suite");
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = mod })).step);

    // Zig has no test discovery: a file's tests run only if something names it,
    // and build.zig cannot read the filesystem to find out. Delete these five
    // lines along with src/kitchen_sink.zig.
    test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/kitchen_sink.zig"),
        .target = target,
        .optimize = optimize,
    }) })).step);
}
