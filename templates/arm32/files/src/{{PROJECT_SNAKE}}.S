        @ Words for {{PROJECT_NAME}}.
        @
        @ AAPCS is the whole calling convention: arguments arrive in r0-r3, the
        @ result goes back in r0, and r4-r11 belong to the caller -- so a word
        @ that wants one pushes it first and pops it before returning.
        @
        @ The comment character is @ here. A hash at column 1 is a C
        @ preprocessor line directive rather than a comment, and /* */ and //
        @ also work -- @ is the GNU assembler convention for ARM.

        @ Directives, not instructions: they tell the assembler what to produce
        @ rather than describing something the chip will do. unified syntax is
        @ the modern ARM/Thumb spelling, and .thumb selects the 16-bit
        @ instruction set this core boots in.
        .syntax unified
        .cpu cortex-m3
        .thumb

        @ The section for code. Read-only data goes in .rodata and zeroed
        @ writable space in .bss, both at the foot of this file -- there is no
        @ heap and nothing allocates, so every byte a program uses is reserved
        @ here at assembly time.
        .text

        @ double ( r0 = n ) -> r0 = n * 2
        @
        @ That comment is the signature. Nothing in the source says what a word
        @ takes or answers, so the convention is to write the registers down --
        @ and the only thing that tells you the comment is wrong is the wrong
        @ answer.
        @
        @ .thumb_func marks the label as Thumb code, which is what makes `bl`
        @ to it work. .global is the whole of visibility: a label is reachable
        @ from another file if it appears in one of these and not otherwise.
        .thumb_func
        .global double
double:
        @ A left shift by one, and the trailing s means "set the condition
        @ flags" -- the flags are the only boolean this machine has, and an
        @ instruction without the s leaves them alone.
        lsls    r0, r0, #1
        @ Branch to the address in lr, the link register, which `bl` put there
        @ when this word was called. That is the return.
        bx      lr

        @ greet ( r0 = name, r1 = length, r2 = buffer ) -> r0 = total length
        @ The caller owns the buffer. There is no allocator, so the only
        @ question a word like this can answer is how much it wrote.
        .thumb_func
        .global greet
greet:
        @ The callee-saved registers this word is about to use, plus lr because
        @ it calls something else and `bl` would overwrite it. Pushing lr and
        @ popping into pc at the end is the idiom: the pop is the return.
        push    {r4, r5, r6, lr}
        @ The arguments are moved out of r0-r3 because `bl copy` below will use
        @ those for its own arguments. Nothing protects them; keeping them is
        @ the caller's job, and here that caller is this word.
        mov     r4, r0
        mov     r5, r1
        mov     r6, r2

        @ ldr with = loads the address of a label, where a bare ldr would load
        @ what is at that address. The literal 7 is the length of "Hello, ",
        @ counted by hand -- a string here is bytes and an address, with no
        @ length stored anywhere and no terminator unless you put one.
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

        @ The answer, in r0 as AAPCS requires: seven for the greeting, the
        @ name, and one for the exclamation mark.
        adds    r0, r5, #8
        pop     {r4, r5, r6, pc}

        @ copy ( r0 = from, r1 = to, r2 = count )
        @
        @ No .global, so this label is private to this file -- the nearest thing
        @ to a private function there is.
copy:
        @ Compare and branch on zero: skip the loop entirely for a count of
        @ nothing. Without it the loop below would copy once before checking.
        cbz     r2, .Lcopied
        @ A label beginning .L is local to this file and is not emitted into the
        @ object. The post-increment on [r0], #1 reads a byte and advances the
        @ pointer in one instruction, which is most of why this loop is four
        @ lines.
.Lbyte: ldrb    r3, [r0], #1
        strb    r3, [r1], #1
        subs    r2, r2, #1
        @ Branch if the flags say the subtract did not reach zero. `subs` set
        @ them; `bne` reads them. Nothing is passed between the two but the
        @ flags, and that is the entire error channel in this language.
        bne     .Lbyte
.Lcopied:
        bx      lr

        @ Read-only data. .ascii lays down exactly these bytes with no
        @ terminator; .asciz would add the zero.
        .section .rodata
hello:  .ascii  "Hello, "
bang:   .ascii  "!"
