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

const io = @import("io.zig");
const vga = @import("vga.zig").getInstance();
const config = @import("../config.zig");

const MultiBoot = extern struct {
    magic: i32,
    flags: i32,
    checksum: i32,
};

// 32 bits / 4 bytes integers
const ALIGN = 1 << 0; // 0000 0000 0000 0000 0000 0000 0000 0001
const MEMINFO = 1 << 1; // 0000 0000 0000 0000 0000 0000 0000 0010
const FLAGS = ALIGN | MEMINFO; // 0000 0000 0000 0000 0000 0000 0000 0000 0011
const MAGIC = 0x1BADB002; // 0001 1011 1010 1101 1011 0000 0000 0010

// Define our stack size
const STACK_SIZE = 16 * 1024; // 16 KB

export var stack_bytes: [STACK_SIZE]u8 align(16) linksection(".bss") = undefined;

export var multiboot align(4) linksection(".multiboot") = MultiBoot{
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export fn kmain() noreturn {
    vga.flush();

    while (true) {}
}

export fn _start() callconv(.naked) noreturn {
    asm volatile (
        \\ mov $stack_bytes, %%esp
        \\ add %[stack_size], %%esp
        \\ call kmain
        :
        : [stack_size] "n" (STACK_SIZE),
    );
}
