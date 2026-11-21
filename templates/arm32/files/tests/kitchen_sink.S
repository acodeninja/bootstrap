        @ Fifteen passing assertions: the toolbox for solving a kata in ARM32
        @ assembly. Most sections are about what the machine does *instead* of
        @ the thing a higher-level language would offer, because at this level
        @ almost none of it exists.

        .syntax unified
        .cpu cortex-m3
        .thumb

        .text
        .thumb_func
        .global main
main:
        push    {r4, lr}
        ldr     r0, =plan_s
        bl      puts

        @ collections
        @ There is no list, no map and no set. There is memory, and a register
        @ holding where in it you are.
        ldr     r4, =values
        ldr     r0, [r4, #8]
        movs    r1, #4
        ldr     r2, =case1
        bl      report_eq

        ldr     r0, =values_end
        ldr     r1, =values
        subs    r0, r0, r1
        asrs    r0, r0, #2
        movs    r1, #4
        ldr     r2, =case2
        bl      report_eq

        movs    r0, #9
        bl      find_value
        mvn     r1, #0
        ldr     r2, =case3
        bl      report_eq

        @ strings
        @ A string is bytes and a convention. Nothing records how many there
        @ are, so either you keep the count or you scan for the terminator.
        ldr     r0, =text
        bl      str_len
        movs    r1, #7
        ldr     r2, =case4
        bl      report_eq

        ldr     r0, =text
        movs    r1, #32
        bl      index_of
        movs    r1, #3
        ldr     r2, =case5
        bl      report_eq

        ldr     r0, =text
        ldrb    r0, [r0, #7]
        movs    r1, #0
        ldr     r2, =case6
        bl      report_eq

        @ types and branching
        @ There are no types. A register is thirty-two bits, and whether they
        @ mean a number, a character or an address is decided by the
        @ instruction you reach for next.
        movs    r0, #0xFF
        sxtb    r0, r0
        mvn     r1, #0
        ldr     r2, =case7
        bl      report_eq

        mvn     r0, #7
        asrs    r0, r0, #1
        mvn     r1, #3
        ldr     r2, =case8
        bl      report_eq

        movs    r0, #7
        cmp     r0, #5
        ite     gt
        movgt   r0, #100
        movle   r0, #200
        movs    r1, #100
        ldr     r2, =case9
        bl      report_eq

        @ iteration
        bl      weighted
        movs    r1, #34
        ldr     r2, =case10
        bl      report_eq

        bl      widest_gap
        movs    r1, #4
        ldr     r2, =case11
        bl      report_eq

        @ functions
        movs    r0, #21
        bl      double
        movs    r1, #42
        ldr     r2, =case12
        bl      report_eq

        movs    r4, #99
        movs    r0, #1
        bl      double
        mov     r0, r4
        movs    r1, #99
        ldr     r2, =case13
        bl      report_eq

        @ errors
        @ Nothing is raised and nothing is returned. The condition flags are
        @ the entire error channel, and they survive exactly one instruction
        @ that cares about them.
        movs    r3, #0
        mvn     r0, #0
        adds    r0, r0, #1
        adc     r3, r3, #0
        mov     r0, r3
        movs    r1, #1
        ldr     r2, =case14
        bl      report_eq

        @ gotchas
        @ The hour this saves. Every address of Thumb code has its low bit set,
        @ and that bit is not part of the address -- it tells the processor
        @ which instruction set to switch to. bx to an even address faults, so
        @ a function pointer you built by arithmetic rather than by asking the
        @ assembler for a symbol will not be callable.
        ldr     r0, =double
        ands    r0, r0, #1
        movs    r1, #1
        ldr     r2, =case15
        bl      report_eq

        pop     {r4, pc}

        @ The helpers the assertions above lean on. A loop is a compare and a
        @ branch; there is nothing else.

        @ find_value ( r0 = wanted ) -> r0 = index, or -1
        .thumb_func
find_value:
        ldr     r1, =values
        movs    r2, #0
.Lfind: cmp     r2, #4
        beq     .Lmiss
        ldr     r3, [r1, r2, lsl #2]
        cmp     r3, r0
        beq     .Lhit
        adds    r2, r2, #1
        b       .Lfind
.Lhit:  mov     r0, r2
        bx      lr
.Lmiss: mvn     r0, #0
        bx      lr

        @ str_len ( r0 = address ) -> r0 = bytes before the NUL
        .thumb_func
str_len:
        movs    r1, #0
.Llen:  ldrb    r2, [r0, r1]
        cbz     r2, .Llen_done
        adds    r1, r1, #1
        b       .Llen
.Llen_done:
        mov     r0, r1
        bx      lr

        @ index_of ( r0 = address, r1 = byte ) -> r0 = index, or -1
        .thumb_func
index_of:
        movs    r2, #0
.Lidx:  ldrb    r3, [r0, r2]
        cbz     r3, .Lidx_miss
        cmp     r3, r1
        beq     .Lidx_hit
        adds    r2, r2, #1
        b       .Lidx
.Lidx_hit:
        mov     r0, r2
        bx      lr
.Lidx_miss:
        mvn     r0, #0
        bx      lr

        @ weighted ( ) -> r0 = sum of index * value, which needs the index
        .thumb_func
weighted:
        ldr     r1, =values
        movs    r0, #0
        movs    r2, #0
.Lwt:   cmp     r2, #4
        beq     .Lwt_done
        ldr     r3, [r1, r2, lsl #2]
        mla     r0, r3, r2, r0
        adds    r2, r2, #1
        b       .Lwt
.Lwt_done:
        bx      lr

        @ widest_gap ( ) -> r0 = largest step between neighbours
        .thumb_func
widest_gap:
        ldr     r1, =values
        movs    r0, #0
        movs    r2, #0
.Lgap:  cmp     r2, #3
        beq     .Lgap_done
        adds    r3, r2, #1
        ldr     r3, [r1, r3, lsl #2]
        ldr     r12, [r1, r2, lsl #2]
        subs    r3, r3, r12
        cmp     r3, r0
        it      gt
        movgt   r0, r3
        adds    r2, r2, #1
        b       .Lgap
.Lgap_done:
        bx      lr

        .section .rodata
        .align  2
values:   .word 1, 2, 4, 8
values_end:
text:     .asciz "one two"

plan_s:   .asciz "1..15\n"
case1:    .asciz "1 - an array is indexed by scaling the index into the load\n"
case2:    .asciz "2 - a length comes from the labels, because an array has no header\n"
case3:    .asciz "3 - a lookup is a linear search returning a sentinel, because there is no map\n"
case4:    .asciz "4 - a string has no length, so finding it means scanning for the NUL\n"
case5:    .asciz "5 - there is no split, so finding the separator is the whole job\n"
case6:    .asciz "6 - the terminator is the convention, and it is a byte like any other\n"
case7:    .asciz "7 - a register is thirty-two bits, and sxtb decides the top twenty-four\n"
case8:    .asciz "8 - asr keeps the sign where lsr would not, on exactly the same bits\n"
case9:    .asciz "9 - an it block is how a branch yields a value without branching\n"
case10:   .asciz "10 - a loop is a compare and a branch, with the index in a register\n"
case11:   .asciz "11 - walking a sequence two at a time means loading both\n"
case12:   .asciz "12 - aapcs puts arguments in r0-r3 and the result back in r0\n"
case13:   .asciz "13 - r4 belongs to the caller, so a word that wants it pushes it first\n"
case14:   .asciz "14 - nothing is raised: the carry flag is the entire error channel\n"
case15:   .asciz "15 - the address of thumb code has its low bit set, and bx needs it\n"
