\ Fifteen passing assertions: the toolbox for solving a kata in Forth.

require ./tester.fs
require ../src/{{PROJECT_SNAKE}}.fs

15 plan

\ collections
\ There is no list, no map and no set. An array is cells you allot and index
\ yourself, and nothing anywhere checks that the index is in range.
create values 4 cells allot
1 values 0 cells + !  2 values 1 cells + !  4 values 2 cells + !  8 values 3 cells + !
4 constant #values

: find-value ( n -- i )
    #values 0 ?do
        dup values i cells + @ = if  drop i unloop exit  then
    loop drop -1 ;

T{ values 2 cells + @ -> 4 }T an array is indexed by scaling the index to cells
T{ #values -> 4 }T the length is a constant you keep, because an array has no header
T{ 9 find-value -> -1 }T a lookup is a linear search returning a sentinel, because there is no map

\ strings
\ A string is an address and a count. Nothing owns it, nothing frees it, and
\ the count is the only length there is.

\ The wanted character goes in a variable, not on the return stack: a do
\ loop keeps its own control parameters there, so r@ inside the loop reads
\ one of those instead.
variable wanted

: index-of ( addr u c -- n )
    wanted !
    0 ?do
        dup i chars + c@ wanted @ = if  drop i unloop exit  then
    loop drop -1 ;

T{ s" abc" nip -> 3 }T a string is an address and a count, so the count is its length
T{ s" abc" s" abd" compare -> -1 }T compare orders two strings rather than only equating them
T{ s" one two" bl index-of -> 3 }T there is no split, so finding the separator is the whole job

\ types and branching
\ There are no types: every value is one cell, and what it means is whatever
\ the word reading it decides.
0 constant >x
1 cells constant >y
create origin 2 cells allot
1 origin >x + !  2 origin >y + !

: describe ( n -- addr u )
    case
        0 of s" zero" endof
        1 of s" one" endof
        drop s" many" 0
    endcase ;

T{ 3 2 > -> -1 }T a true flag is -1 and not 1, which matters the moment you do arithmetic on it
T{ origin >y + @ -> 2 }T a record is named offsets into cells you allot
T{ 1 describe s" one" compare -> 0 }T case yields a value by leaving it on the stack

\ iteration
: weighted ( -- n )
    0 #values 0 ?do  values i cells + @ i * +  loop ;

: widest-gap ( -- n )
    0 #values 1- 0 ?do  values i 1+ cells + @ values i cells + @ - max  loop ;

T{ weighted -> 34 }T do loop puts the index in i, which is the only way to reach it
T{ widest-gap -> 4 }T walking a sequence two at a time means indexing both

\ functions
variable combiner

: double ( n -- n ) 2* ;

: reduce ( xt init -- n )
    swap combiner !
    #values 0 ?do  values i cells + @ combiner @ execute  loop ;

T{ 21 ' double execute -> 42 }T an execution token is how a word is handed to another word
T{ ' max 0 reduce -> 8 }T a fold takes the xt of the word that combines two values

\ errors
: refuse ( -- ) 7 throw ;

T{ ' refuse catch -> 7 }T catch returns the code throw raised, and zero when nothing did

\ gotchas
\ The hour this saves. endcase drops the top cell to get rid of the selector,
\ which it has to because an of branch already consumed it. A default branch
\ that leaves a result therefore has that result dropped instead, and the word
\ returns the selector. The describe above pushes a throwaway zero for endcase
\ to eat; this one does not.
: naive ( n -- n )
    case
        0 of 10 endof
        1 of 20 endof
        30
    endcase ;

T{ 7 naive -> 7 }T a default branch that yields a value returns the selector, because endcase drops the top

tap-done
