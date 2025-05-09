//! SPDX-License-Identifier: BSD-3-Clause
//!
//! Copyright (c) 2025 Klementiev Dmitry <klementievd08@yandex.ru>
//!
//! Redistribution and use in source and binary forms, with or without modification,
//! are permitted provided that the following conditions are met:
//!
//! 1. Redistributions of source code must retain the above copyright
//!    notice, this list of conditions and the following disclaimer.
//! 2. Redistributions in binary form must reproduce the above copyright
//!    notice, this list of conditions and the following disclaimer in the documentation
//!    and/or other materials provided with the distribution.
//! 3. Neither the name of the copyright holder nor the names of its contributors
//!    may be used to endorse or promote products derived from this software without
//!    specific prior written permission.
//!
//! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//! ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//! FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//! DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//! SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
//! AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//! EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

buffer: [*]volatile u16,

const Self = @This();

pub const WIDTH = 80;
pub const HEIGHT = 25;
const BUFFER_ADDRESS = 0xB8000;

var instance = Self{
    .buffer = @ptrFromInt(BUFFER_ADDRESS),
};

pub fn getInstance() *Self {
    return &instance;
}

pub fn flush(self: *Self) void {
    var y: usize = 0;
    while (y < HEIGHT) : (y += 1) {
        var x: usize = 0;
        while (x < WIDTH) : (x += 1) {
            self.writeAt(' ', 0, x, y);
        }
    }
}

pub fn writeAt(self: *Self, char: u8, color: u8, x: usize, y: usize) void {
    const index = y * WIDTH + x;
    self.buffer[index] = createEntry(char, color);
}

fn createEntry(char: u8, color: u8) u16 {
    const c: u16 = color;
    return char | (c << 8);
}
