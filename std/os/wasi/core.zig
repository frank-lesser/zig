pub const __wasi_errno_t = u16;
pub const __wasi_exitcode_t = u32;
pub const __wasi_fd_t = u32;
pub const __wasi_signal_t = u8;

pub const __wasi_ciovec_t = extern struct {
    buf: [*]const u8,
    buf_len: usize,
};

pub const __WASI_SIGABRT: __wasi_signal_t = 6;

pub extern "wasi" fn __wasi_proc_raise(sig: __wasi_signal_t) __wasi_errno_t;

pub extern "wasi" fn __wasi_proc_exit(rval: __wasi_exitcode_t) noreturn;

pub extern "wasi" fn __wasi_fd_write(fd: __wasi_fd_t, iovs: *const __wasi_ciovec_t, iovs_len: usize, nwritten: *usize) __wasi_errno_t;
