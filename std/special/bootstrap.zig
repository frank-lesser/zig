// This file is in a package which has the root source file exposed as "@root".
// It is included in the compilation unit when exporting an executable.

const root = @import("@root");
const std = @import("std");
const builtin = @import("builtin");

var argc_ptr: [*]usize = undefined;

comptime {
    const strong_linkage = builtin.GlobalLinkage.Strong;
    if (builtin.link_libc) {
        @export("main", main, strong_linkage);
    } else if (builtin.os == builtin.Os.windows) {
        @export("WinMainCRTStartup", WinMainCRTStartup, strong_linkage);
    } else {
        @export("_start", _start, strong_linkage);
    }
}

nakedcc fn _start() noreturn {
    switch (builtin.arch) {
        builtin.Arch.x86_64 => switch (builtin.os) {
            builtin.Os.freebsd => {
                argc_ptr = asm ("lea (%%rdi), %[argc]"
                    : [argc] "=r" (-> [*]usize)
                );
            },
            else => {
                argc_ptr = asm ("lea (%%rsp), %[argc]"
                    : [argc] "=r" (-> [*]usize)
                );
            },
        },
        builtin.Arch.i386 => {
            argc_ptr = asm ("lea (%%esp), %[argc]"
                : [argc] "=r" (-> [*]usize)
            );
        },
        builtin.Arch.aarch64v8 => {
            argc_ptr = asm ("mov %[argc], sp"
                : [argc] "=r" (-> [*]usize)
            );
        },
        else => @compileError("unsupported arch"),
    }
    // If LLVM inlines stack variables into _start, they will overwrite
    // the command line argument data.
    @noInlineCall(posixCallMainAndExit);
}

extern fn WinMainCRTStartup() noreturn {
    @setAlignStack(16);

    std.os.windows.ExitProcess(callMain());
}

// TODO https://github.com/ziglang/zig/issues/265
fn posixCallMainAndExit() noreturn {
    if (builtin.os == builtin.Os.freebsd) {
        @setAlignStack(16);
    }
    const argc = argc_ptr[0];
    const argv = @ptrCast([*][*]u8, argc_ptr + 1);

    const envp_optional = @ptrCast([*]?[*]u8, argv + argc + 1);
    var envp_count: usize = 0;
    while (envp_optional[envp_count]) |_| : (envp_count += 1) {}
    const envp = @ptrCast([*][*]u8, envp_optional)[0..envp_count];
    if (builtin.os == builtin.Os.linux) {
        const auxv = @ptrCast([*]usize, envp.ptr + envp_count + 1);
        std.os.linux_elf_aux_maybe = @ptrCast([*]std.elf.Auxv, auxv);
        std.debug.assert(std.os.linuxGetAuxVal(std.elf.AT_PAGESZ) == std.os.page_size);
    }

    std.os.posix.exit(callMainWithArgs(argc, argv, envp));
}

// This is marked inline because for some reason LLVM in release mode fails to inline it,
// and we want fewer call frames in stack traces.
inline fn callMainWithArgs(argc: usize, argv: [*][*]u8, envp: [][*]u8) u8 {
    std.os.ArgIteratorPosix.raw = argv[0..argc];
    std.os.posix_environ_raw = envp;
    return callMain();
}

extern fn main(c_argc: i32, c_argv: [*][*]u8, c_envp: [*]?[*]u8) i32 {
    var env_count: usize = 0;
    while (c_envp[env_count] != null) : (env_count += 1) {}
    const envp = @ptrCast([*][*]u8, c_envp)[0..env_count];
    return callMainWithArgs(@intCast(usize, c_argc), c_argv, envp);
}

// This is marked inline because for some reason LLVM in release mode fails to inline it,
// and we want fewer call frames in stack traces.
inline fn callMain() u8 {
    switch (@typeId(@typeOf(root.main).ReturnType)) {
        builtin.TypeId.NoReturn => {
            root.main();
        },
        builtin.TypeId.Void => {
            root.main();
            return 0;
        },
        builtin.TypeId.Int => {
            if (@typeOf(root.main).ReturnType.bit_count != 8) {
                @compileError("expected return type of main to be 'u8', 'noreturn', 'void', or '!void'");
            }
            return root.main();
        },
        builtin.TypeId.ErrorUnion => {
            root.main() catch |err| {
                std.debug.warn("error: {}\n", @errorName(err));
                if (builtin.os != builtin.Os.zen) {
                    if (@errorReturnTrace()) |trace| {
                        std.debug.dumpStackTrace(trace);
                    }
                }
                return 1;
            };
            return 0;
        },
        else => @compileError("expected return type of main to be 'u8', 'noreturn', 'void', or '!void'"),
    }
}
