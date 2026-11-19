//! Fifteen passing assertions: the toolbox for solving a kata in Zig.
//! Deleting this file means deleting the block in build.zig that names it.

const std = @import("std");
const testing = std.testing;

// collections

test "a list keeps what you put in it, in order" {
    const gpa = testing.allocator;
    var items: std.ArrayList([]const u8) = .empty;
    defer items.deinit(gpa);

    try items.append(gpa, "a");
    try items.append(gpa, "b");
    try items.append(gpa, "c");

    try testing.expectEqual(3, items.items.len);
    try testing.expectEqualStrings("b", items.items[1]);
    try testing.expectEqual(2, items.items[1..3].len);
}

test "a lookup for a key that is not there comes back empty" {
    const gpa = testing.allocator;
    var counts = std.StringHashMap(u32).init(gpa);
    defer counts.deinit();

    try counts.put("a", 2);

    try testing.expectEqual(2, counts.get("a").?);
    try testing.expectEqual(null, counts.get("z"));
    try testing.expectEqual(0, counts.get("z") orelse 0);
}

test "a set is a map whose values carry nothing" {
    const gpa = testing.allocator;
    var letters = std.AutoHashMap(u8, void).init(gpa);
    defer letters.deinit();

    for ("aba") |letter| try letters.put(letter, {});

    try testing.expectEqual(2, letters.count());
    try testing.expect(letters.contains('a'));
    try testing.expect(!letters.contains('z'));
}

// strings

test "a string splits into parts you walk one at a time" {
    var parts = std.mem.splitScalar(u8, "one two three", ' ');

    try testing.expectEqualStrings("one", parts.next().?);
    try testing.expectEqualStrings("two", parts.next().?);
    try testing.expectEqualStrings("three", parts.next().?);
    try testing.expectEqual(null, parts.next());
}

test "a slice of a string counts from zero" {
    const text = "abcdef";

    try testing.expectEqual('a', text[0]);
    try testing.expectEqualStrings("abc", text[0..3]);
    try testing.expectEqualStrings("ef", text[text.len - 2 ..]);
}

test "text is built by formatting into a buffer you own" {
    var buffer: [64]u8 = undefined;

    const line = try std.fmt.bufPrint(&buffer, "{s} x{d}", .{ "world", 2 });

    try testing.expectEqualStrings("world x2", line);
    try testing.expectEqualStrings("padded", std.mem.trim(u8, "  padded  ", " "));
}

// types and branching

test "assigning a struct copies it" {
    const Point = struct { x: i32, y: i32 };
    const point: Point = .{ .x = 1, .y = 2 };

    var moved = point;
    moved.x = 5;

    try testing.expectEqual(5, moved.x);
    try testing.expectEqual(1, point.x);
}

test "a switch over an enum has to cover every case" {
    // Leave one of the two prongs out and this stops compiling. That check is
    // the reason to reach for an enum over a pair of strings.
    const State = enum { locked, open };
    const state: State = .locked;

    const next: State = switch (state) {
        .locked => .open,
        .open => .locked,
    };

    try testing.expectEqual(State.open, next);
}

test "a branch produces a value instead of setting one" {
    const cases = [_]struct { n: i32, label: []const u8 }{
        .{ .n = -1, .label = "negative" },
        .{ .n = 0, .label = "zero" },
        .{ .n = 1, .label = "positive" },
    };

    for (cases) |case| {
        const label = if (case.n < 0) "negative" else if (case.n == 0) "zero" else "positive";

        try testing.expectEqualStrings(case.label, label);
    }
}

// iteration

test "a loop can read both the position and the item" {
    const items = [_][]const u8{ "a", "b", "c" };
    var found: ?usize = null;

    for (items, 0..) |item, index| {
        if (std.mem.eql(u8, item, "b")) found = index;
    }

    try testing.expectEqual(1, found.?);
}

test "a sequence can be walked two items at a time" {
    const values = [_]u8{ 1, 2, 3, 4 };
    var sums: [3]u8 = undefined;
    var index: usize = 0;

    var pairs = std.mem.window(u8, &values, 2, 1);
    while (pairs.next()) |pair| : (index += 1) sums[index] = pair[0] + pair[1];

    try testing.expectEqualSlices(u8, &.{ 3, 5, 7 }, &sums);
}

// functions

fn double(n: i32) i32 {
    return n * 2;
}

fn mapInPlace(values: []i32, apply: fn (i32) i32) void {
    for (values) |*value| value.* = apply(value.*);
}

test "a function can be handed to another function" {
    var values = [_]i32{ 1, 2, 3 };

    mapInPlace(&values, double);

    try testing.expectEqualSlices(i32, &.{ 2, 4, 6 }, &values);
}

test "a list is folded by looping, because there is no reduce" {
    const values = [_]i32{ 1, 2, 3, 4 };

    var total: i32 = 0;
    for (values) |value| total += value;

    try testing.expectEqual(10, total);
}

// errors

const PercentageError = error{NotAPercentage};

fn parsePercentage(input: []const u8) PercentageError!u8 {
    const value = std.fmt.parseInt(u8, input, 10) catch return error.NotAPercentage;
    if (value > 100) return error.NotAPercentage;
    return value;
}

test "an invalid input is refused rather than guessed at" {
    try testing.expectEqual(40, try parsePercentage("40"));
    try testing.expectError(error.NotAPercentage, parsePercentage("half"));
    try testing.expectError(error.NotAPercentage, parsePercentage("140"));
}

// gotchas

test "an integer too big for its type is an error, not a wrap" {
    // Plain `nearly_full + 10` does not wrap either: it panics in a debug
    // build. Say which one you meant.
    const nearly_full: u8 = 250;

    try testing.expectError(error.Overflow, std.math.add(u8, nearly_full, 10));
    try testing.expectEqual(4, nearly_full +% 10);
}
