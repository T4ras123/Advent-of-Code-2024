const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    // Open the input file
    const read_file = try std.fs.cwd().openFile(
        "input.txt",
        .{ .mode = .read_only },
    );
    defer read_file.close();

    // Read the entire file content
    const content = try read_file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(content);

    // Split the content into lines
    const lines = std.mem.splitAny(u8, content, "\n");

    var it = lines;
    var num_of_safe: u32 = 0;

    // Iterate over each line
    while (it.next()) |line| {
        // Split the line into items separated by spaces
        var it2 = std.mem.splitAny(u8, line, " ");

        // Get the first number in the line
        const first_item = it2.next() orelse continue;
        var prev = std.fmt.parseInt(i32, first_item, 10) catch continue;

        // Get the second number to determine direction
        const second_item = it2.next() orelse {
            // Only one number, consider it safe
            num_of_safe += 1;
            continue;
        };
        const current = std.fmt.parseInt(i32, second_item, 10) catch {
            // Failed to parse second number, skip line
            continue;
        };

        var direction: enum { ascending, descending } = .ascending;

        if (current > prev) {
            direction = .ascending;
        } else if (current < prev) {
            direction = .descending;
        } else {
            // Equal numbers, no direction, consider invalid
            continue;
        }

        // Check maximum difference
        if (@abs(current - prev) > 2) {
            continue;
        }

        // Update prev
        prev = current;

        var is_safe: bool = true;

        // Iterate over the remaining numbers in the line
        while (it2.next()) |item| {
            const num = std.fmt.parseInt(i32, item, 10) catch {
                is_safe = false;
                break;
            };

            // Check the absolute difference
            if (@abs(num - prev) > 2) {
                is_safe = false;
                break;
            }

            // Check direction
            if (direction == .ascending) {
                if (num < prev) {
                    is_safe = false;
                    break;
                }
            } else { // descending
                if (num > prev) {
                    is_safe = false;
                    break;
                }
            }

            // Update prev
            prev = num;
        }

        if (is_safe) {
            num_of_safe += 1;
        }
    }

    print("Number of safe sequences: {}\n", .{num_of_safe});
}