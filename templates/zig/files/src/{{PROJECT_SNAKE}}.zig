const std = @import("std");

// `pub` is what makes this reachable from another file; without it the function
// is private to this one. A Zig file is a struct, so importing it gives you that
// struct and `pub` decides which of its declarations you can see.
//
// Two things in this signature are the whole of Zig's character. The caller
// passes `buffer`, because nothing here allocates on your behalf: there is no
// hidden allocator and no garbage collector, so memory arrives as an argument or
// it does not arrive. And the return type begins with `!`, making it an error
// union -- this either gives you a slice or an error, and the caller has to deal
// with both.
pub fn greet(buffer: []u8, name: []const u8) ![]u8 {
    // bufPrint formats into the buffer it was handed and returns a slice of
    // just the part it filled. It fails when the text will not fit, and that
    // failure is what the `!` above is for. {s} is the specifier for a string.
    return std.fmt.bufPrint(buffer, "Hello, {s}!", .{name});
}

// `test` is a declaration like `fn` or `const`, not a framework: the name is a
// string so it can be a real sentence, and `zig build test` runs every test in
// the files it is told to build.
//
// Zig has no test discovery, so build.zig has to name a file for its tests to
// run at all -- it names this one, and probes for the kitchen sink rather than
// naming it, which is what keeps that file deletable.
test "a greeting addresses the name it is given" {
    // `undefined` means genuinely uninitialised, not null and not zero. It is
    // fine here because bufPrint writes before anything reads, and reading it
    // first would be a bug the compiler does not catch.
    var buffer: [64]u8 = undefined;

    // `try` is the error half of the union: it unwraps the value, or returns
    // the error from this test, which fails it. A test is just a function that
    // can fail, so returning an error is how it reports one.
    const greeting = try greet(&buffer, "world");

    // expectEqualStrings rather than expectEqual, because a slice is a pointer
    // and a length -- comparing two slices with expectEqual compares those,
    // not the characters they point at.
    try std.testing.expectEqualStrings("Hello, world!", greeting);
}
