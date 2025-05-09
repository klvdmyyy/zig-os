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

const Cursor = @import("cursor.zig");

const VGADriver = struct {
    const Self = @This();

    const VIDEO_MEMORY: *volatile u16 = 0xB8000;
    const MAX_COLS: i32 = 80;
    const MAX_ROWS: i32 = 25;

    var cursor = Cursor{
        .max_cols = MAX_COLS,
        .max_rows = MAX_ROWS,
    };

    var video = VIDEO_MEMORY;

    pub fn putChar(c: u16) void {
        video[(cursor.getRow() * MAX_COLS + cursor.getCol()) * 2] = c;
        video[(cursor.getRow() * MAX_COLS + cursor.getCol()) * 2 + 1] = 0x07;
        cursor.next();
    }
};
