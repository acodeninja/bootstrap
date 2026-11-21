\ T{ <code> -> <expected> }T <name>
\
\ Twenty lines rather than a dependency: defining the vocabulary you want is
\ what Forth is for, and the Forth 2012 test suite's T{ -> }T is the shape
\ every Forth programmer already reads. This one prints TAP, so the runner can
\ tell a failed assertion from a program that stopped part way through.

32 constant max-results
create produced max-results cells allot
variable #produced
variable start-depth
variable #cases
variable #failed
variable matched

: plan ( n -- ) ." 1.." 0 .r cr  0 #cases !  0 #failed ! ;

: T{ ( -- ) depth start-depth ! ;

\ Everything the code left is stashed, topmost first, so the expected values
\ typed after -> can be compared against it one at a time.
: -> ( x*n -- )
   depth start-depth @ - dup #produced !
   0 ?do  produced i cells + !  loop ;

: rest-of-line ( -- addr u )
   source >in @ /string  source nip >in ! ;

\ The flag lives in a variable, not on the stack: an accumulator on top of the
\ values being compared is comparing itself.
: same? ( x*n -- flag )
   depth start-depth @ - #produced @ <> if
      depth start-depth @ - 0 ?do drop loop  false exit
   then
   true matched !
   #produced @ 0 ?do  produced i cells + @ <> if  false matched !  then  loop
   matched @ ;

: }T ( x*n -- )
   same?  #cases @ 1+ dup #cases !  rest-of-line
   2>r swap if ." ok " else ." not ok " 1 #failed +! then
   0 .r ."  - " 2r> type cr ;

: tap-done ( -- ) #failed @ 0<> if 1 else 0 then (bye) ;
