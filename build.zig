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

const std = @import("std");
const fmt = std.fmt;
const Target = std.Target;
const CrossTarget = std.Target.Query;

const config = @import("config.zig");

pub fn build(b: *std.Build) void {
    var _binaryName: [100]u8 = undefined;
    var _outputFile: [100]u8 = undefined;
    const binaryName = fmt.bufPrint(_binaryName[0..], "{s}.bin", .{config.KERNEL_NAME}) catch unreachable;
    const outputFile = fmt.bufPrint(_outputFile[0..], "zig-out/bin/{s}", .{binaryName}) catch unreachable;

    const targetQuery = CrossTarget{
        .cpu_arch = Target.Cpu.Arch.x86,
        .os_tag = Target.Os.Tag.freestanding,
    };

    const target = b.resolveTargetQuery(targetQuery);

    const optimize = b.standardOptimizeOption(.{});

    const bootloader = b.addExecutable(.{
        .name = binaryName,
        .root_source_file = b.path("bootloader/boot.zig"),
        .target = target,
        .optimize = optimize,
    });

    bootloader.setLinkerScript(b.path("bootloader/linker.ld"));
    bootloader.pie = false;
    b.installArtifact(bootloader);

    const run_cmd = b.addSystemCommand(&.{
        "C:\\Program Files\\qemu\\qemu-system-x86_64",
        "-kernel",
        outputFile,
        "-serial",
        "null",
    });

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the OS in QEMU");
    run_step.dependOn(&run_cmd.step);
}
