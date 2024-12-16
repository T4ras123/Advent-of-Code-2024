const std = @import("std");
const print = std.debug.print;

const MyError = error{
    InvalidFormat,
};

pub fn main() !void {

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    const read_file = try std.fs.cwd().openFile(
        "input.txt",
        .{ .mode = .read_only },
    );
    defer read_file.close();

    const content = try read_file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

    const lines = std.mem.splitAny(u8, content, "\n");

    var list1 = std.ArrayList(i32).init(allocator);
    defer list1.deinit();
    var list2 = std.ArrayList(i32).init(allocator);
    defer list2.deinit();

    var it = lines;

    while (it.next()) |line| {
        var numbers = std.mem.splitSequence(u8, line, "   ");

        const num1_str = numbers.next() orelse return MyError.InvalidFormat;
        const num2_str = numbers.next() orelse return MyError.InvalidFormat;

        const num1 = std.fmt.parseInt(i32, num1_str, 10) catch return MyError.InvalidFormat;
        const num2 = std.fmt.parseInt(i32, num2_str, 10) catch return MyError.InvalidFormat;

        try list1.append(num1);
        try list2.append(num2);
    }

    std.mem.sort(i32, list1.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, comptime std.sort.asc(i32));

    const it1 = list1.items;
    const it2 = list2.items;

    var similarity: i32 = 0;
    for (it1) |num1| {
        var count: i32 = 0;
        for (it2) |num2| {
            if (num1 == num2) {
                count += 1;
            }
        }
        similarity += count*num1;
    }
    print("Similarity: {}\n", .{similarity});
}