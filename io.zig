//! Basic I/O implementation

const VIDEO_MEMORY: *volatile u16 = 0xB8000;
const MAX_COLS: i32 = 80;
const MAX_ROWS: i32 = 25;

pub fn print(message: *const u16) void {
    var row: i32 = 0;
    var col: i32 = 0;

    var video = VIDEO_MEMORY;

    var i: usize = 0;
    while (message[i] != '\x00') : (i += 1) {
        video[(row * MAX_COLS + col) * 2] = message[i];
        video[(row * MAX_COLS + col) * 2 + 1] = 0x07;
        if (col + 1 >= MAX_COLS) {
            col = 0;
            row += 1;
        }
        if (row >= MAX_ROWS) {
            row = 0;
        }
    }
}

pub fn printf(comptime message: *const u16, args: anytype) void {
    const std = @import("std");
    try std.fmt.format(print, message, args);
}
