/*
 * Copyright (c) 2015 Andrew Kelley
 *
 * This file is part of zig, which is MIT licensed.
 * See http://opensource.org/licenses/MIT
 */

#ifndef ERROR_HPP
#define ERROR_HPP

#include <assert.h>

enum Error {
    ErrorNone,
    ErrorNoMem,
    ErrorInvalidFormat,
    ErrorSemanticAnalyzeFail,
    ErrorAccess,
    ErrorInterrupted,
    ErrorSystemResources,
    ErrorFileNotFound,
    ErrorFileSystem,
    ErrorFileTooBig,
    ErrorDivByZero,
    ErrorOverflow,
    ErrorPathAlreadyExists,
    ErrorUnexpected,
    ErrorExactDivRemainder,
    ErrorNegativeDenominator,
    ErrorShiftedOutOneBits,
    ErrorCCompileErrors,
    ErrorEndOfFile,
    ErrorIsDir,
    ErrorNotDir,
    ErrorUnsupportedOperatingSystem,
    ErrorSharingViolation,
    ErrorPipeBusy,
    ErrorPrimitiveTypeNotFound,
    ErrorCacheUnavailable,
    ErrorPathTooLong,
    ErrorCCompilerCannotFindFile,
    ErrorReadingDepFile,
    ErrorInvalidDepFile,
    ErrorMissingArchitecture,
    ErrorMissingOperatingSystem,
    ErrorUnknownArchitecture,
    ErrorUnknownOperatingSystem,
    ErrorUnknownABI,
    ErrorInvalidFilename,
};

const char *err_str(Error err);

static inline void assertNoError(Error err) {
    assert(err == ErrorNone);
}

#endif
