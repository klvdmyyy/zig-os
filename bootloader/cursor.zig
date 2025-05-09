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

max_cols: i32,
max_rows: i32,

const Self = @This();

var row: i32 = 0;
var col: i32 = 0;

// Some getters
pub fn getRow() i32 {
    return row;
}
pub fn getCol() i32 {
    return col;
}

pub fn moveLeft() void {
    if (col == 0 and row > 0) {
        col = Self.max_cols;
        row -= 1;
    } else {
        col -= 1;
    }
}

pub fn moveRight() void {
    if (col + 1 >= Self.max_cols) {
        col = 0;
        row += 1;
    }
    if (row >= Self.max_col) {
        row = 0;
    }
}

pub fn next() void {
    moveRight();
}
