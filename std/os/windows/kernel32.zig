use @import("index.zig");

pub extern "kernel32" stdcallcc fn CancelIoEx(hFile: HANDLE, lpOverlapped: LPOVERLAPPED) BOOL;

pub extern "kernel32" stdcallcc fn CloseHandle(hObject: HANDLE) BOOL;

pub extern "kernel32" stdcallcc fn CreateDirectoryW(lpPathName: [*]const u16, lpSecurityAttributes: ?*SECURITY_ATTRIBUTES) BOOL;

pub extern "kernel32" stdcallcc fn CreateFileW(
    lpFileName: [*]const u16, // TODO null terminated pointer type
    dwDesiredAccess: DWORD,
    dwShareMode: DWORD,
    lpSecurityAttributes: ?LPSECURITY_ATTRIBUTES,
    dwCreationDisposition: DWORD,
    dwFlagsAndAttributes: DWORD,
    hTemplateFile: ?HANDLE,
) HANDLE;

pub extern "kernel32" stdcallcc fn CreatePipe(
    hReadPipe: *HANDLE,
    hWritePipe: *HANDLE,
    lpPipeAttributes: *const SECURITY_ATTRIBUTES,
    nSize: DWORD,
) BOOL;

pub extern "kernel32" stdcallcc fn CreateProcessW(
    lpApplicationName: ?LPWSTR,
    lpCommandLine: LPWSTR,
    lpProcessAttributes: ?*SECURITY_ATTRIBUTES,
    lpThreadAttributes: ?*SECURITY_ATTRIBUTES,
    bInheritHandles: BOOL,
    dwCreationFlags: DWORD,
    lpEnvironment: ?*c_void,
    lpCurrentDirectory: ?LPWSTR,
    lpStartupInfo: *STARTUPINFOW,
    lpProcessInformation: *PROCESS_INFORMATION,
) BOOL;

pub extern "kernel32" stdcallcc fn CreateSymbolicLinkW(lpSymlinkFileName: [*]const u16, lpTargetFileName: [*]const u16, dwFlags: DWORD) BOOLEAN;

pub extern "kernel32" stdcallcc fn CreateIoCompletionPort(FileHandle: HANDLE, ExistingCompletionPort: ?HANDLE, CompletionKey: ULONG_PTR, NumberOfConcurrentThreads: DWORD) ?HANDLE;

pub extern "kernel32" stdcallcc fn CreateThread(lpThreadAttributes: ?LPSECURITY_ATTRIBUTES, dwStackSize: SIZE_T, lpStartAddress: LPTHREAD_START_ROUTINE, lpParameter: ?LPVOID, dwCreationFlags: DWORD, lpThreadId: ?LPDWORD) ?HANDLE;

pub extern "kernel32" stdcallcc fn DeleteFileW(lpFileName: [*]const u16) BOOL;

pub extern "kernel32" stdcallcc fn ExitProcess(exit_code: UINT) noreturn;

pub extern "kernel32" stdcallcc fn FindFirstFileW(lpFileName: [*]const u16, lpFindFileData: *WIN32_FIND_DATAW) HANDLE;
pub extern "kernel32" stdcallcc fn FindClose(hFindFile: HANDLE) BOOL;
pub extern "kernel32" stdcallcc fn FindNextFileW(hFindFile: HANDLE, lpFindFileData: *WIN32_FIND_DATAW) BOOL;

pub extern "kernel32" stdcallcc fn FreeEnvironmentStringsA(penv: [*]u8) BOOL;

pub extern "kernel32" stdcallcc fn GetCommandLineA() LPSTR;

pub extern "kernel32" stdcallcc fn GetConsoleMode(in_hConsoleHandle: HANDLE, out_lpMode: *DWORD) BOOL;

pub extern "kernel32" stdcallcc fn GetConsoleScreenBufferInfo(hConsoleOutput: HANDLE, lpConsoleScreenBufferInfo: *CONSOLE_SCREEN_BUFFER_INFO) BOOL;

pub extern "kernel32" stdcallcc fn GetCurrentDirectoryW(nBufferLength: DWORD, lpBuffer: ?[*]WCHAR) DWORD;

pub extern "kernel32" stdcallcc fn GetCurrentThread() HANDLE;
pub extern "kernel32" stdcallcc fn GetCurrentThreadId() DWORD;

pub extern "kernel32" stdcallcc fn GetEnvironmentStringsA() ?[*]u8;

pub extern "kernel32" stdcallcc fn GetEnvironmentVariableA(lpName: LPCSTR, lpBuffer: LPSTR, nSize: DWORD) DWORD;

pub extern "kernel32" stdcallcc fn GetExitCodeProcess(hProcess: HANDLE, lpExitCode: *DWORD) BOOL;

pub extern "kernel32" stdcallcc fn GetFileSizeEx(hFile: HANDLE, lpFileSize: *LARGE_INTEGER) BOOL;

pub extern "kernel32" stdcallcc fn GetFileAttributesW(lpFileName: [*]const WCHAR) DWORD;

pub extern "kernel32" stdcallcc fn GetModuleFileNameW(hModule: ?HMODULE, lpFilename: [*]u16, nSize: DWORD) DWORD;

pub extern "kernel32" stdcallcc fn GetModuleHandleW(lpModuleName: ?[*]const WCHAR) HMODULE;

pub extern "kernel32" stdcallcc fn GetLastError() DWORD;

pub extern "kernel32" stdcallcc fn GetFileInformationByHandleEx(
    in_hFile: HANDLE,
    in_FileInformationClass: FILE_INFO_BY_HANDLE_CLASS,
    out_lpFileInformation: *c_void,
    in_dwBufferSize: DWORD,
) BOOL;

pub extern "kernel32" stdcallcc fn GetFinalPathNameByHandleW(
    hFile: HANDLE,
    lpszFilePath: [*]u16,
    cchFilePath: DWORD,
    dwFlags: DWORD,
) DWORD;

pub extern "kernel32" stdcallcc fn GetOverlappedResult(hFile: HANDLE, lpOverlapped: *OVERLAPPED, lpNumberOfBytesTransferred: *DWORD, bWait: BOOL) BOOL;

pub extern "kernel32" stdcallcc fn GetProcessHeap() ?HANDLE;
pub extern "kernel32" stdcallcc fn GetQueuedCompletionStatus(CompletionPort: HANDLE, lpNumberOfBytesTransferred: LPDWORD, lpCompletionKey: *ULONG_PTR, lpOverlapped: *?*OVERLAPPED, dwMilliseconds: DWORD) BOOL;

pub extern "kernel32" stdcallcc fn GetSystemInfo(lpSystemInfo: *SYSTEM_INFO) void;
pub extern "kernel32" stdcallcc fn GetSystemTimeAsFileTime(*FILETIME) void;

pub extern "kernel32" stdcallcc fn HeapCreate(flOptions: DWORD, dwInitialSize: SIZE_T, dwMaximumSize: SIZE_T) ?HANDLE;
pub extern "kernel32" stdcallcc fn HeapDestroy(hHeap: HANDLE) BOOL;
pub extern "kernel32" stdcallcc fn HeapReAlloc(hHeap: HANDLE, dwFlags: DWORD, lpMem: *c_void, dwBytes: SIZE_T) ?*c_void;
pub extern "kernel32" stdcallcc fn HeapSize(hHeap: HANDLE, dwFlags: DWORD, lpMem: *const c_void) SIZE_T;
pub extern "kernel32" stdcallcc fn HeapCompact(hHeap: HANDLE, dwFlags: DWORD) SIZE_T;
pub extern "kernel32" stdcallcc fn HeapSummary(hHeap: HANDLE, dwFlags: DWORD, lpSummary: LPHEAP_SUMMARY) BOOL;

pub extern "kernel32" stdcallcc fn GetStdHandle(in_nStdHandle: DWORD) ?HANDLE;

pub extern "kernel32" stdcallcc fn HeapAlloc(hHeap: HANDLE, dwFlags: DWORD, dwBytes: SIZE_T) ?*c_void;

pub extern "kernel32" stdcallcc fn HeapFree(hHeap: HANDLE, dwFlags: DWORD, lpMem: *c_void) BOOL;

pub extern "kernel32" stdcallcc fn HeapValidate(hHeap: HANDLE, dwFlags: DWORD, lpMem: ?*const c_void) BOOL;

pub extern "kernel32" stdcallcc fn MoveFileExW(
    lpExistingFileName: [*]const u16,
    lpNewFileName: [*]const u16,
    dwFlags: DWORD,
) BOOL;

pub extern "kernel32" stdcallcc fn PostQueuedCompletionStatus(CompletionPort: HANDLE, dwNumberOfBytesTransferred: DWORD, dwCompletionKey: ULONG_PTR, lpOverlapped: ?*OVERLAPPED) BOOL;

pub extern "kernel32" stdcallcc fn QueryPerformanceCounter(lpPerformanceCount: *LARGE_INTEGER) BOOL;

pub extern "kernel32" stdcallcc fn QueryPerformanceFrequency(lpFrequency: *LARGE_INTEGER) BOOL;

pub extern "kernel32" stdcallcc fn ReadDirectoryChangesW(
    hDirectory: HANDLE,
    lpBuffer: [*]align(@alignOf(FILE_NOTIFY_INFORMATION)) u8,
    nBufferLength: DWORD,
    bWatchSubtree: BOOL,
    dwNotifyFilter: DWORD,
    lpBytesReturned: ?*DWORD,
    lpOverlapped: ?*OVERLAPPED,
    lpCompletionRoutine: LPOVERLAPPED_COMPLETION_ROUTINE,
) BOOL;

pub extern "kernel32" stdcallcc fn ReadFile(
    in_hFile: HANDLE,
    out_lpBuffer: [*]u8,
    in_nNumberOfBytesToRead: DWORD,
    out_lpNumberOfBytesRead: ?*DWORD,
    in_out_lpOverlapped: ?*OVERLAPPED,
) BOOL;

pub extern "kernel32" stdcallcc fn RemoveDirectoryW(lpPathName: [*]const u16) BOOL;

pub extern "kernel32" stdcallcc fn SetConsoleTextAttribute(hConsoleOutput: HANDLE, wAttributes: WORD) BOOL;

pub extern "kernel32" stdcallcc fn SetFilePointerEx(
    in_fFile: HANDLE,
    in_liDistanceToMove: LARGE_INTEGER,
    out_opt_ldNewFilePointer: ?*LARGE_INTEGER,
    in_dwMoveMethod: DWORD,
) BOOL;

pub extern "kernel32" stdcallcc fn SetHandleInformation(hObject: HANDLE, dwMask: DWORD, dwFlags: DWORD) BOOL;

pub extern "kernel32" stdcallcc fn Sleep(dwMilliseconds: DWORD) void;

pub extern "kernel32" stdcallcc fn TerminateProcess(hProcess: HANDLE, uExitCode: UINT) BOOL;

pub extern "kernel32" stdcallcc fn WaitForSingleObject(hHandle: HANDLE, dwMilliseconds: DWORD) DWORD;

pub extern "kernel32" stdcallcc fn WriteFile(
    in_hFile: HANDLE,
    in_lpBuffer: [*]const u8,
    in_nNumberOfBytesToWrite: DWORD,
    out_lpNumberOfBytesWritten: ?*DWORD,
    in_out_lpOverlapped: ?*OVERLAPPED,
) BOOL;

pub extern "kernel32" stdcallcc fn WriteFileEx(hFile: HANDLE, lpBuffer: [*]const u8, nNumberOfBytesToWrite: DWORD, lpOverlapped: LPOVERLAPPED, lpCompletionRoutine: LPOVERLAPPED_COMPLETION_ROUTINE) BOOL;

pub extern "kernel32" stdcallcc fn LoadLibraryW(lpLibFileName: [*]const u16) ?HMODULE;

pub extern "kernel32" stdcallcc fn GetProcAddress(hModule: HMODULE, lpProcName: [*]const u8) ?FARPROC;

pub extern "kernel32" stdcallcc fn FreeLibrary(hModule: HMODULE) BOOL;

pub const FILE_NOTIFY_INFORMATION = extern struct {
    NextEntryOffset: DWORD,
    Action: DWORD,
    FileNameLength: DWORD,
    FileName: [1]WCHAR,
};

pub const FILE_ACTION_ADDED = 0x00000001;
pub const FILE_ACTION_REMOVED = 0x00000002;
pub const FILE_ACTION_MODIFIED = 0x00000003;
pub const FILE_ACTION_RENAMED_OLD_NAME = 0x00000004;
pub const FILE_ACTION_RENAMED_NEW_NAME = 0x00000005;

pub const LPOVERLAPPED_COMPLETION_ROUTINE = ?extern fn (DWORD, DWORD, *OVERLAPPED) void;

pub const FILE_LIST_DIRECTORY = 1;

pub const FILE_NOTIFY_CHANGE_CREATION = 64;
pub const FILE_NOTIFY_CHANGE_SIZE = 8;
pub const FILE_NOTIFY_CHANGE_SECURITY = 256;
pub const FILE_NOTIFY_CHANGE_LAST_ACCESS = 32;
pub const FILE_NOTIFY_CHANGE_LAST_WRITE = 16;
pub const FILE_NOTIFY_CHANGE_DIR_NAME = 2;
pub const FILE_NOTIFY_CHANGE_FILE_NAME = 1;
pub const FILE_NOTIFY_CHANGE_ATTRIBUTES = 4;

pub const CONSOLE_SCREEN_BUFFER_INFO = extern struct {
    dwSize: COORD,
    dwCursorPosition: COORD,
    wAttributes: WORD,
    srWindow: SMALL_RECT,
    dwMaximumWindowSize: COORD,
};

pub const FOREGROUND_BLUE = 1;
pub const FOREGROUND_GREEN = 2;
pub const FOREGROUND_RED = 4;
pub const FOREGROUND_INTENSITY = 8;
