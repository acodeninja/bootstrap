const std = @import("std");

pub fn greet(buffer: []u8, name: []const u8) ![]u8 {
    return std.fmt.bufPrint(buffer, "Hello, {s}!", .{name});
}

test "a greeting addresses the name it is given" {
    var buffer: [64]u8 = undefined;

    const greeting = try greet(&buffer, "world");

    try std.testing.expectEqualStrings("Hello, world!", greeting);
}
