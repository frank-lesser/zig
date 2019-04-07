const expect = @import("std").testing.expect;
const builtin = @import("builtin");

var foo: u8 align(4) = 100;

test "global variable alignment" {
    expect(@typeOf(&foo).alignment == 4);
    expect(@typeOf(&foo) == *align(4) u8);
    const slice = (*[1]u8)(&foo)[0..];
    expect(@typeOf(slice) == []align(4) u8);
}

fn derp() align(@sizeOf(usize) * 2) i32 {
    return 1234;
}
fn noop1() align(1) void {}
fn noop4() align(4) void {}

test "function alignment" {
    expect(derp() == 1234);
    expect(@typeOf(noop1) == fn () align(1) void);
    expect(@typeOf(noop4) == fn () align(4) void);
    noop1();
    noop4();
}

var baz: packed struct {
    a: u32,
    b: u32,
} = undefined;

test "packed struct alignment" {
    expect(@typeOf(&baz.b) == *align(1) u32);
}

const blah: packed struct {
    a: u3,
    b: u3,
    c: u2,
} = undefined;

test "bit field alignment" {
    expect(@typeOf(&blah.b) == *align(1:3:1) const u3);
}

test "default alignment allows unspecified in type syntax" {
    expect(*u32 == *align(@alignOf(u32)) u32);
}

test "implicitly decreasing pointer alignment" {
    const a: u32 align(4) = 3;
    const b: u32 align(8) = 4;
    expect(addUnaligned(&a, &b) == 7);
}

fn addUnaligned(a: *align(1) const u32, b: *align(1) const u32) u32 {
    return a.* + b.*;
}

test "implicitly decreasing slice alignment" {
    const a: u32 align(4) = 3;
    const b: u32 align(8) = 4;
    expect(addUnalignedSlice((*const [1]u32)(&a)[0..], (*const [1]u32)(&b)[0..]) == 7);
}
fn addUnalignedSlice(a: []align(1) const u32, b: []align(1) const u32) u32 {
    return a[0] + b[0];
}

test "specifying alignment allows pointer cast" {
    testBytesAlign(0x33);
}
fn testBytesAlign(b: u8) void {
    var bytes align(4) = []u8{
        b,
        b,
        b,
        b,
    };
    const ptr = @ptrCast(*u32, &bytes[0]);
    expect(ptr.* == 0x33333333);
}

test "specifying alignment allows slice cast" {
    testBytesAlignSlice(0x33);
}
fn testBytesAlignSlice(b: u8) void {
    var bytes align(4) = []u8{
        b,
        b,
        b,
        b,
    };
    const slice: []u32 = @bytesToSlice(u32, bytes[0..]);
    expect(slice[0] == 0x33333333);
}

test "@alignCast pointers" {
    var x: u32 align(4) = 1;
    expectsOnly1(&x);
    expect(x == 2);
}
fn expectsOnly1(x: *align(1) u32) void {
    expects4(@alignCast(4, x));
}
fn expects4(x: *align(4) u32) void {
    x.* += 1;
}

test "@alignCast slices" {
    var array align(4) = []u32{
        1,
        1,
    };
    const slice = array[0..];
    sliceExpectsOnly1(slice);
    expect(slice[0] == 2);
}
fn sliceExpectsOnly1(slice: []align(1) u32) void {
    sliceExpects4(@alignCast(4, slice));
}
fn sliceExpects4(slice: []align(4) u32) void {
    slice[0] += 1;
}

test "implicitly decreasing fn alignment" {
    testImplicitlyDecreaseFnAlign(alignedSmall, 1234);
    testImplicitlyDecreaseFnAlign(alignedBig, 5678);
}

fn testImplicitlyDecreaseFnAlign(ptr: fn () align(1) i32, answer: i32) void {
    expect(ptr() == answer);
}

fn alignedSmall() align(8) i32 {
    return 1234;
}
fn alignedBig() align(16) i32 {
    return 5678;
}

test "@alignCast functions" {
    expect(fnExpectsOnly1(simple4) == 0x19);
}
fn fnExpectsOnly1(ptr: fn () align(1) i32) i32 {
    return fnExpects4(@alignCast(4, ptr));
}
fn fnExpects4(ptr: fn () align(4) i32) i32 {
    return ptr();
}
fn simple4() align(4) i32 {
    return 0x19;
}

test "generic function with align param" {
    expect(whyWouldYouEverDoThis(1) == 0x1);
    expect(whyWouldYouEverDoThis(4) == 0x1);
    expect(whyWouldYouEverDoThis(8) == 0x1);
}

fn whyWouldYouEverDoThis(comptime align_bytes: u8) align(align_bytes) u8 {
    return 0x1;
}

test "@ptrCast preserves alignment of bigger source" {
    var x: u32 align(16) = 1234;
    const ptr = @ptrCast(*u8, &x);
    expect(@typeOf(ptr) == *align(16) u8);
}

test "runtime known array index has best alignment possible" {
    // take full advantage of over-alignment
    var array align(4) = []u8{ 1, 2, 3, 4 };
    expect(@typeOf(&array[0]) == *align(4) u8);
    expect(@typeOf(&array[1]) == *u8);
    expect(@typeOf(&array[2]) == *align(2) u8);
    expect(@typeOf(&array[3]) == *u8);

    // because align is too small but we still figure out to use 2
    var bigger align(2) = []u64{ 1, 2, 3, 4 };
    expect(@typeOf(&bigger[0]) == *align(2) u64);
    expect(@typeOf(&bigger[1]) == *align(2) u64);
    expect(@typeOf(&bigger[2]) == *align(2) u64);
    expect(@typeOf(&bigger[3]) == *align(2) u64);

    // because pointer is align 2 and u32 align % 2 == 0 we can assume align 2
    var smaller align(2) = []u32{ 1, 2, 3, 4 };
    comptime expect(@typeOf(smaller[0..]) == []align(2) u32);
    comptime expect(@typeOf(smaller[0..].ptr) == [*]align(2) u32);
    testIndex(smaller[0..].ptr, 0, *align(2) u32);
    testIndex(smaller[0..].ptr, 1, *align(2) u32);
    testIndex(smaller[0..].ptr, 2, *align(2) u32);
    testIndex(smaller[0..].ptr, 3, *align(2) u32);

    // has to use ABI alignment because index known at runtime only
    testIndex2(array[0..].ptr, 0, *u8);
    testIndex2(array[0..].ptr, 1, *u8);
    testIndex2(array[0..].ptr, 2, *u8);
    testIndex2(array[0..].ptr, 3, *u8);
}
fn testIndex(smaller: [*]align(2) u32, index: usize, comptime T: type) void {
    comptime expect(@typeOf(&smaller[index]) == T);
}
fn testIndex2(ptr: [*]align(4) u8, index: usize, comptime T: type) void {
    comptime expect(@typeOf(&ptr[index]) == T);
}

test "alignstack" {
    expect(fnWithAlignedStack() == 1234);
}

fn fnWithAlignedStack() i32 {
    @setAlignStack(256);
    return 1234;
}

test "alignment of structs" {
    expect(@alignOf(struct {
        a: i32,
        b: *i32,
    }) == @alignOf(usize));
}

test "alignment of extern() void" {
    var runtime_nothing = nothing;
    const casted1 = @ptrCast(*const u8, runtime_nothing);
    const casted2 = @ptrCast(extern fn () void, casted1);
    casted2();
}

extern fn nothing() void {}
