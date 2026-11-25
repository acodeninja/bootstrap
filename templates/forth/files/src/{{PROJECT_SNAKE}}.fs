\ Words for {{PROJECT_NAME}}. A test file reaches these with
\ `require ../src/{{PROJECT_SNAKE}}.fs` -- Forth has no module system beyond
\ that, and every word it defines is visible everywhere afterwards.
\
\ There is one dictionary and it is global. `require` is the whole of
\ visibility: a word is either defined or it is not, and nothing is private.
\ That is why the helper below is named `>greeting` rather than `add` -- a
\ short name here is a short name in every file that requires this one.

\ A string is an address and a count, and you own the memory. Building one
\ means allotting a buffer and tracking how much of it you have filled.
create greeting 64 chars allot
variable #greeting

\ `:` opens a definition and `;` closes it. Between them, the name comes first
\ and then the body, which is a list of words that run in order -- there are no
\ parameters and no return type, because everything travels on the stack.
\
\ ( addr u -- ) is the stack effect, and it is the signature. To the left of the
\ -- is what the word consumes, topmost item last; to the right is what it
\ leaves. Nothing checks it, so it is a promise to the reader rather than to the
\ compiler, and a word whose body disagrees with its comment is the single most
\ common bug in Forth. Write it first and keep it true.
: >greeting ( addr u -- )
    greeting #greeting @ chars + swap dup >r move
    #greeting @ r> + #greeting ! ;

\ The word under test. It takes a string and leaves one, so the caller passes
\ nothing by name and receives nothing by name: `s" world" greet` puts an
\ address and a count on the stack, and whatever runs next consumes them.
: greet ( addr u -- addr u )
    0 #greeting !
    s" Hello, " >greeting
    >greeting
    s" !" >greeting
    greeting #greeting @ ;
