const config = @import("builtin");
const assert = @import("std").debug.assert;

comptime {
    if (config.arch == config.Arch.x86_64 and config.os == config.Os.linux) {
        asm volatile (
            \\.globl aoeu;
            \\.type aoeu, @function;
            \\.set aoeu, derp;
        );
    }
}

test "module level assembly" {
    if (config.arch == config.Arch.x86_64 and config.os == config.Os.linux) {
        assert(aoeu() == 1234);
    }
}

test "output constraint modifiers" {
    // This is only testing compilation.
    var a: u32 = 3;
    asm volatile ("" : [_]"=m,r"(a) : : "");
    asm volatile ("" : [_]"=r,m"(a) : : "");
}

test "alternative constraints" {
    // Make sure we allow commas as a separator for alternative constraints.
    var a: u32 = 3;
    asm volatile ("" : [_]"=r,m"(a) : [_]"r,m"(a) : "");
}

test "sized integer/float in asm input" {
    asm volatile ("" : : [_]"m"(usize(3)) : "");
    asm volatile ("" : : [_]"m"(i15(-3)) : "");
    asm volatile ("" : : [_]"m"(u3(3)) : "");
    asm volatile ("" : : [_]"m"(i3(3)) : "");
    asm volatile ("" : : [_]"m"(u121(3)) : "");
    asm volatile ("" : : [_]"m"(i121(3)) : "");
    asm volatile ("" : : [_]"m"(f32(3.17)) : "");
    asm volatile ("" : : [_]"m"(f64(3.17)) : "");
}

extern fn aoeu() i32;

export fn derp() i32 {
    return 1234;
}
