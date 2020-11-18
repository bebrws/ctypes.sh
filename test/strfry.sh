#!/bin/bash

source ctypes.sh
set -e

dlcall -n hwstr -r pointer strdup "hello, world"

# Check that the string was duplicated
if test "$(dlcall -r int puts $hwstr)" != "hello, world"; then
    echo FAIL
    exit 1
fi

if dlsym strfry >/dev/null 2>&1; then
    # Check that we can modify it
    dlcall -r pointer strfry $hwstr
else
    dlcall -r pointer memmove $hwstr "a" ulong:1
fi

if test "$(dlcall -r int puts $DLRETVAL)" == "hello, world"; then
    echo FAIL
    exit 1
fi

echo PASS
