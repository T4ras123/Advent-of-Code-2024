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

    var it = lines;
    while (it.next()) |line| {
        print ("line: {s}\n", .{line});
    }

}