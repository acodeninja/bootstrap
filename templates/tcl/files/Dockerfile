# syntax=docker/dockerfile:1
FROM debian:trixie-20261104-slim

# tcl pulls in libtcl8.6, which ships tcltest as a Tcl module, so
# `package require tcltest` resolves with no second package to install.
#
# The datestamped base tag already fixes the package set; an apt version pin on
# top of it only breaks the build when Debian rotates its snapshots.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends tcl \
    && rm -rf /var/lib/apt/lists/*

# runAllTests globs tests/*.test itself, so neither this nor the Makefile names
# a test file. It reports what failed and then *returns* whether anything did,
# exiting for nothing -- so without the exit below a red assertion would leave
# make test green.
#
# -notfile defaults to l.*.test, which silently skips every test file whose
# name begins with l. Emptying it is the difference between a suite that runs
# and one that says nothing about tests/lexer.test.
COPY --chmod=0755 <<'TCL' /usr/local/bin/tcltest-all
#!/usr/bin/env tclsh
package require tcltest

if {![file isdirectory tests]} {
    puts "no tests found under tests/"
    exit 0
}

tcltest::configure -testdir tests -tmpdir /cache/tcltest -notfile {}
exit [tcltest::runAllTests]
TCL

# Tcl raises nothing when it parses a broken file: the byte-compiler turns a
# parse error into a `syntax` instruction that fires only if the code runs, and
# byte-compiling therefore succeeds on anything. So the instruction is the
# verdict, and the literal it was handed is the message. The base image pins
# 8.6.16, so neither the opcode nor the shape around it moves under us.
COPY --chmod=0755 <<'TCL' /usr/local/bin/tcl-check
#!/usr/bin/env tclsh

proc parse_error {src} {
    set bytecode [::tcl::unsupported::getbytecode script $src]
    set instructions [dict values [dict get $bytecode instructions]]
    set at [lsearch -glob $instructions {syntax *}]
    if {$at < 0} {
        return ""
    }

    # The compiler pushes the message, then the return options, then raises.
    set push [lindex $instructions $at-2]
    return [lindex [dict get $bytecode literals] \
        [string trimleft [lindex $push 1] @]]
}

proc sources {dir patterns} {
    set found {}
    foreach pattern $patterns {
        lappend found {*}[glob -nocomplain -directory $dir $pattern]
    }
    foreach subdir [glob -nocomplain -type d -directory $dir *] {
        lappend found {*}[sources $subdir $patterns]
    }
    return $found
}

set status 0

foreach file [lsort [sources . {*.tcl *.test}]] {
    set channel [open $file r]
    set src [read $channel]
    close $channel

    set error [parse_error $src]
    if {$error eq ""} {
        puts "ok $file"
    } else {
        puts stderr "$file: $error"
        set status 1
    }
}

exit $status
TCL

ENV HOME=/cache/home

# Empty and world-writable so the first run creates its files as whoever is
# calling. See docs/containers.md "File ownership".
RUN mkdir -p /cache/home /cache/tcltest && chmod -R 777 /cache

WORKDIR /work
