const config = @import("builtin");
const expect = @import("std").testing.expect;

comptime {
    if (config.arch == config.Arch.x86_64 and config.os == config.Os.linux) {
        asm volatile (
            \\.globl this_is_my_alias;
            \\.type this_is_my_alias, @function;
            \\.set this_is_my_alias, derp;
        );
    }
}

test "module level assembly" {
    if (config.arch == config.Arch.x86_64 and config.os == config.Os.linux) {
        expect(this_is_my_alias() == 1234);
    }
}

test "output constraint modifiers" {
    // This is only testing compilation.
    var a: u32 = 3;
    asm volatile (""
        : [_] "=m,r" (a)
        :
        : ""
    );
    asm volatile (""
        : [_] "=r,m" (a)
        :
        : ""
    );
}

test "alternative constraints" {
    // Make sure we allow commas as a separator for alternative constraints.
    var a: u32 = 3;
    asm volatile (""
        : [_] "=r,m" (a)
        : [_] "r,m" (a)
        : ""
    );
}

test "sized integer/float in asm input" {
    asm volatile (""
        :
        : [_] "m" (usize(3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (i15(-3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (u3(3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (i3(3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (u121(3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (i121(3))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (f32(3.17))
        : ""
    );
    asm volatile (""
        :
        : [_] "m" (f64(3.17))
        : ""
    );
}

extern fn this_is_my_alias() i32;

export fn derp() i32 {
    return 1234;
}
