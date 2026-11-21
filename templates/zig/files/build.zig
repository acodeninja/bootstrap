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

    // Zig has no test discovery: a file's tests run only if something names it
    // as a module root. Naming it conditionally is what lets you delete
    // src/kitchen_sink.zig without editing this file too.
    //
    // dependOnDirectoryMetadata is what makes that sound. The configure phase
    // is cached against build.zig's own contents, so without it the graph
    // outlives the file and still names a source that is no longer there.
    b.dependOnDirectoryMetadata(b.path("src"));
    const sink = b.root.joinString(b.allocator, "src/kitchen_sink.zig") catch @panic("OOM");
    if (b.root.root_dir.handle.access(b.graph.io, sink, .{})) |_| {
        test_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path("src/kitchen_sink.zig"),
            .target = target,
            .optimize = optimize,
        }) })).step);
    } else |_| {}
}
