const expect = @import("std").testing.expect;
const expectEqual = @import("std").testing.expectEqual;
const a_namespace = @import("import/a_namespace.zig");

test "call fn via namespace lookup" {
    expectEqual(i32(1234), a_namespace.foo());
}

test "importing the same thing gives the same import" {
    expect(@import("std") == @import("std"));
}

test "import in non-toplevel scope" {
    const S = struct {
        use @import("import/a_namespace.zig");
    };
    expectEqual(i32(1234), S.foo());
}
