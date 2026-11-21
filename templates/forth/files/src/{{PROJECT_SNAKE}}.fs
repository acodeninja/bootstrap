\ Words for {{PROJECT_NAME}}. A test file reaches these with
\ `require ../src/{{PROJECT_SNAKE}}.fs` -- Forth has no module system beyond
\ that, and every word it defines is visible everywhere afterwards.

\ A string is an address and a count, and you own the memory. Building one
\ means allotting a buffer and tracking how much of it you have filled.
create greeting 64 chars allot
variable #greeting

: >greeting ( addr u -- )
    greeting #greeting @ chars + swap dup >r move
    #greeting @ r> + #greeting ! ;

: greet ( addr u -- addr u )
    0 #greeting !
    s" Hello, " >greeting
    >greeting
    s" !" >greeting
    greeting #greeting @ ;
