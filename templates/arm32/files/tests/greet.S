        .syntax unified
        .cpu cortex-m3
        .thumb

        .text
        .thumb_func
        .global main
main:
        push    {lr}
        ldr     r0, =plan_s
        bl      puts

        ldr     r0, =name
        movs    r1, #5
        ldr     r2, =buffer
        bl      greet
        movs    r1, #13
        ldr     r2, =case1
        bl      report_eq

        pop     {pc}

        .section .rodata
plan_s: .asciz  "1..1\n"
name:   .ascii  "world"
case1:  .asciz  "1 - a greeting is as long as its parts put together\n"

        .section .bss
        .align  2
buffer: .space  32
