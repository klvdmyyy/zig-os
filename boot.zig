const io = @import("io.zig");
const config = @import("config.zig");

export fn bmain() noreturn {
    io.printf("Loading {s}-{d}.{d}.{d} ...", .{
        config.KERNEL_NAME,
        config.KERNEL_VERSION_MAJOR,
        config.KERNEL_VERSION_MINOR,
        config.KERNEL_VERSION_PATCH,
    });
}

export fn _start() callconv(.naked) noreturn {
    asm volatile (
        \\ ;; TODO: Start bootloader. Load kernel
    );
}
