        @ Nothing names this file. make test assembles and links every
        @ tests/*.S into its own firmware image, boots each one under qemu and
        @ reads the TAP it prints over semihosting -- so a test is found by
        @ existing and deleting one is safe. Run the suite with make test.
        @
        @ There is no operating system here. The image is a Cortex-M3 firmware,
        @ and src/start.S is the reset handler that sets up a stack and calls
        @ main -- which is why a test file defines main and nothing else global.

        .syntax unified
        .cpu cortex-m3
        .thumb

        .text
        .thumb_func
        .global main
main:
        @ lr has to be preserved because this word calls others. pop {pc} at
        @ the end is the return.
        push    {lr}
        @ TAP opens with the plan. puts comes from start.S, not from a library:
        @ there is no libc in the image, so printing is semihosting -- a magic
        @ instruction the emulator intercepts.
        ldr     r0, =plan_s
        bl      puts

        @ Arguments into r0, r1 and r2, exactly as greet documents them: the
        @ address of the name, its length counted by hand, and a buffer we own.
        @ Nothing checks any of this -- getting a register wrong gives a wrong
        @ answer rather than an error.
        ldr     r0, =name
        movs    r1, #5
        ldr     r2, =buffer
        bl      greet
        @ greet left its answer in r0 and report_eq compares r0 against r1,
        @ printing ok or not ok with the message at r2. So the assertion is
        @ three registers set in the right order, and the expected value is a
        @ literal 13 counted by hand.
        movs    r1, #13
        ldr     r2, =case1
        bl      report_eq

        pop     {pc}

        @ The strings. .asciz adds the terminating zero that puts needs;
        @ .ascii does not, which is why `name` has none -- greet is told the
        @ length instead.
        @
        @ The plan has to agree with the number of report_eq calls above:
        @ nothing counts them for you, and the runner checks.
        @
        @ case1 is the test name, and the leading "1 - " is part of the TAP
        @ line rather than decoration.
        .section .rodata
plan_s: .asciz  "1..1\n"
name:   .ascii  "world"
case1:  .asciz  "1 - a greeting is as long as its parts put together\n"

        @ Zeroed writable space, reserved at assembly time because there is no
        @ allocator to ask. .align 2 puts it on a four-byte boundary, which the
        @ word-sized accesses elsewhere need.
        .section .bss
        .align  2
buffer: .space  32
