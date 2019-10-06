const std = @import("std");
const expect = std.testing.expect;

test "@byteSwap integers" {
    const ByteSwapIntTest = struct {
        fn run() void {
            t(u0, 0, 0);
            t(u8, 0x12, 0x12);
            t(u16, 0x1234, 0x3412);
            t(u24, 0x123456, 0x563412);
            t(u32, 0x12345678, 0x78563412);
            t(u40, 0x123456789a, 0x9a78563412);
            t(i48, 0x123456789abc, @bitCast(i48, u48(0xbc9a78563412)));
            t(u56, 0x123456789abcde, 0xdebc9a78563412);
            t(u64, 0x123456789abcdef1, 0xf1debc9a78563412);
            t(u128, 0x123456789abcdef11121314151617181, 0x8171615141312111f1debc9a78563412);

            t(u0, u0(0), 0);
            t(i8, i8(-50), -50);
            t(i16, @bitCast(i16, u16(0x1234)), @bitCast(i16, u16(0x3412)));
            t(i24, @bitCast(i24, u24(0x123456)), @bitCast(i24, u24(0x563412)));
            t(i32, @bitCast(i32, u32(0x12345678)), @bitCast(i32, u32(0x78563412)));
            t(u40, @bitCast(i40, u40(0x123456789a)), u40(0x9a78563412));
            t(i48, @bitCast(i48, u48(0x123456789abc)), @bitCast(i48, u48(0xbc9a78563412)));
            t(i56, @bitCast(i56, u56(0x123456789abcde)), @bitCast(i56, u56(0xdebc9a78563412)));
            t(i64, @bitCast(i64, u64(0x123456789abcdef1)), @bitCast(i64, u64(0xf1debc9a78563412)));
            t(
                i128,
                @bitCast(i128, u128(0x123456789abcdef11121314151617181)),
                @bitCast(i128, u128(0x8171615141312111f1debc9a78563412)),
            );
        }
        fn t(comptime I: type, input: I, expected_output: I) void {
            std.testing.expectEqual(expected_output, @byteSwap(I, input));
        }
    };
    comptime ByteSwapIntTest.run();
    ByteSwapIntTest.run();
}

test "@byteSwap vectors" {
    // Disabled because of #3317
    if (@import("builtin").arch == .mipsel) return error.SkipZigTest;

    const ByteSwapVectorTest = struct {
        fn run() void {
            t(u8, 2, [_]u8{ 0x12, 0x13 }, [_]u8{ 0x12, 0x13 });
            t(u16, 2, [_]u16{ 0x1234, 0x2345 }, [_]u16{ 0x3412, 0x4523 });
            t(u24, 2, [_]u24{ 0x123456, 0x234567 }, [_]u24{ 0x563412, 0x674523 });
        }

        fn t(
            comptime I: type,
            comptime n: comptime_int,
            input: @Vector(n, I),
            expected_vector: @Vector(n, I),
        ) void {
            const actual_output: [n]I = @byteSwap(I, input);
            const expected_output: [n]I = expected_vector;
            std.testing.expectEqual(expected_output, actual_output);
        }
    };
    comptime ByteSwapVectorTest.run();
    ByteSwapVectorTest.run();
}
