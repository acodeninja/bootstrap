        @ Words for {{PROJECT_NAME}}.
        @
        @ AAPCS is the whole calling convention: arguments arrive in r0-r3, the
        @ result goes back in r0, and r4-r11 belong to the caller -- so a word
        @ that wants one pushes it first and pops it before returning.

        .syntax unified
        .cpu cortex-m3
        .thumb

        .text

        @ double ( r0 = n ) -> r0 = n * 2
        .thumb_func
        .global double
double:
        lsls    r0, r0, #1
        bx      lr

        @ greet ( r0 = name, r1 = length, r2 = buffer ) -> r0 = total length
        @ The caller owns the buffer. There is no allocator, so the only
        @ question a word like this can answer is how much it wrote.
        .thumb_func
        .global greet
greet:
        push    {r4, r5, r6, lr}
        mov     r4, r0
        mov     r5, r1
        mov     r6, r2

        ldr     r0, =hello
        mov     r1, r6
        movs    r2, #7
        bl      copy

        mov     r0, r4
        add     r1, r6, #7
        mov     r2, r5
        bl      copy

        ldr     r0, =bang
        add     r1, r6, #7
        add     r1, r1, r5
        movs    r2, #1
        bl      copy

        adds    r0, r5, #8
        pop     {r4, r5, r6, pc}

        @ copy ( r0 = from, r1 = to, r2 = count )
        .thumb_func
copy:
        cbz     r2, .Lcopied
.Lbyte: ldrb    r3, [r0], #1
        strb    r3, [r1], #1
        subs    r2, r2, #1
        bne     .Lbyte
.Lcopied:
        bx      lr

        .section .rodata
hello:  .ascii  "Hello, "
bang:   .ascii  "!"
