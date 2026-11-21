        .syntax unified
        .cpu cortex-m3
        .thumb

        @ Semihosting: bkpt 0xAB is the call, r0 the operation, r1 its argument.
        @ It is how a program on an emulated chip reaches the host at all --
        @ there is no operating system here and no stdout to write to.
        .equ SYS_WRITE0, 0x04
        .equ SYS_EXIT,   0x18
        .equ APP_EXIT,   0x20026

        @ The vector table is the first thing at address zero: the initial
        @ stack pointer, then the address the chip jumps to on reset.
        .section .vectors, "a"
        .word   _stack_top
        .word   reset

        .text
        .thumb_func
        .global reset
reset:
        bl      main

        .thumb_func
        .global finish
finish:
        movs    r0, #SYS_EXIT
        ldr     r1, =APP_EXIT
        bkpt    #0xAB
spin:   b       spin

        @ puts ( r0 = address of a NUL-terminated string )
        .thumb_func
        .global puts
puts:
        mov     r1, r0
        movs    r0, #SYS_WRITE0
        bkpt    #0xAB
        bx      lr

        @ report_eq ( r0 = actual, r1 = expected, r2 = "N - name\n" )
        @ One TAP line per call. r4 is callee-saved, so it is pushed first.
        .thumb_func
        .global report_eq
report_eq:
        push    {r4, lr}
        mov     r4, r2
        cmp     r0, r1
        beq     .Lpass
        ldr     r0, =not_ok_s
        bl      puts
        b       .Lname
.Lpass:
        ldr     r0, =ok_s
        bl      puts
.Lname:
        mov     r0, r4
        bl      puts
        pop     {r4, pc}

        .section .rodata
ok_s:     .asciz "ok "
not_ok_s: .asciz "not ok "
