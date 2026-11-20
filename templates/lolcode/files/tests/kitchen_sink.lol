HAI 1.2
  BTW  Fifteen passing assertions: the toolbox for solving a kata in LOLCODE.

  HOW IZ I report YR num AN YR passed AN YR name
    passed
    O RLY?
      YA RLY
        VISIBLE SMOOSH "ok " AN num AN " - " AN name MKAY
      NO WAI
        VISIBLE SMOOSH "not ok " AN num AN " - " AN name MKAY
    OIC
  IF U SAY SO

  BTW  A function is the only place a branch can produce a value, because
  BTW  O RLY? and WTF? are statements. FOUND YR is the way out of each arm.
  HOW IZ I describe YR state
    state
    WTF?
      OMG "locked"
        FOUND YR "shut"
      OMG "unlocked"
        FOUND YR "open"
      OMGWTF
        FOUND YR "anything else"
    OIC
  IF U SAY SO

  HOW IZ I adds YR a AN YR b
    FOUND YR SUM OF a AN b
  IF U SAY SO

  BTW  A function can call itself even though it cannot be handed anywhere.
  HOW IZ I upto YR n
    BOTH SAEM n AN 0
    O RLY?
      YA RLY
        FOUND YR 0
      NO WAI
        FOUND YR SUM OF n AN I IZ upto YR DIFF OF n AN 1 MKAY
    OIC
  IF U SAY SO

  VISIBLE "1..15"

  BTW  collections

  I HAS A box ITZ A BUKKIT
  box HAS A first ITZ "a"
  box HAS A second ITZ "b"
  box'Z second R "B"
  I IZ report YR 1 AN YR BOTH OF BOTH SAEM box'Z first AN "a" AN BOTH SAEM box'Z second AN "B" AN YR "a bukkit holds the slots you name" MKAY

  BTW  There is no array type. SRS turns a number into a slot name, which is
  BTW  as close as the language gets, and nothing reports how many there are.
  I HAS A row ITZ A BUKKIT
  row HAS A SRS 0 ITZ "a"
  row HAS A SRS 1 ITZ "b"
  row HAS A SRS 2 ITZ "a"
  I IZ report YR 2 AN YR BOTH SAEM row'Z SRS 1 AN "b" AN YR "SRS numbers a slot, which is the nearest thing to an array" MKAY

  BTW  No set type either, so uniqueness is something you count.
  I HAS A seen ITZ 0
  IM IN YR looking UPPIN YR i TIL BOTH SAEM i AN 3
    BOTH SAEM row'Z SRS i AN "a"
    O RLY?
      YA RLY
        seen R SUM OF seen AN 1
    OIC
  IM OUTTA YR looking
  I IZ report YR 3 AN YR BOTH SAEM seen AN 2 AN YR "counting is how you ask what a set would answer" MKAY

  BTW  strings

  BTW  SMOOSH is the whole of the string library: there is no length, no
  BTW  substring and no split. It does take numbers, and casts them for you.
  I HAS A joined ITZ SMOOSH "one" AN "-" AN "two" MKAY
  I HAS A counted ITZ SMOOSH "two" AN 2 MKAY
  I IZ report YR 4 AN YR BOTH OF BOTH SAEM joined AN "one-two" AN BOTH SAEM counted AN "two2" AN YR "SMOOSH joins text, and numbers without being asked" MKAY

  I IZ report YR 5 AN YR BOTH OF BOTH SAEM "ab" AN "ab" AN DIFFRINT "ab" AN "ba" AN YR "whole strings compare, and nothing smaller can" MKAY

  I HAS A parsed ITZ MAEK "42" A NUMBR
  I IZ report YR 6 AN YR BOTH SAEM parsed AN 42 AN YR "MAEK is the only parsing there is" MKAY

  BTW  types and branching

  I IZ report YR 7 AN YR BOTH OF BOTH OF WIN AN WIN AN NOT FAIL AN YR "a TROOF is WIN or FAIL, and BOTH OF is and" MKAY

  BTW  A bukkit is a reference. Two names for one bukkit are one bukkit.
  I HAS A alias ITZ box
  alias'Z first R "z"
  I IZ report YR 8 AN YR BOTH SAEM box'Z first AN "z" AN YR "a bukkit is shared, so an alias writes through it" MKAY

  I HAS A open ITZ I IZ describe YR "unlocked" MKAY
  I HAS A other ITZ I IZ describe YR "melted" MKAY
  I IZ report YR 9 AN YR BOTH OF BOTH SAEM open AN "open" AN BOTH SAEM other AN "anything else" AN YR "a branch yields a value only by returning from a function" MKAY

  BTW  iteration

  I HAS A weighted ITZ 0
  IM IN YR counting UPPIN YR i TIL BOTH SAEM i AN 4
    weighted R SUM OF weighted AN PRODUKT OF i AN i
  IM OUTTA YR counting
  I IZ report YR 10 AN YR BOTH SAEM weighted AN 14 AN YR "UPPIN counts up and TIL says when to stop" MKAY

  I HAS A steps ITZ 0
  IM IN YR shrinking NERFIN YR i TIL BOTH SAEM i AN -3
    steps R SUM OF steps AN 1
  IM OUTTA YR shrinking
  I IZ report YR 11 AN YR BOTH SAEM steps AN 3 AN YR "NERFIN counts down, and WILE has to follow one of them" MKAY

  BTW  functions

  I HAS A sum ITZ I IZ adds YR 2 AN YR 3 MKAY
  I IZ report YR 12 AN YR BOTH SAEM sum AN 5 AN YR "a function takes arguments and FOUND YR returns" MKAY

  I HAS A folded ITZ I IZ upto YR 4 MKAY
  I IZ report YR 13 AN YR BOTH SAEM folded AN 10 AN YR "a function can call itself, but cannot be handed anywhere" MKAY

  BTW  errors

  BTW  Nothing can be caught. A division by zero ends the program where it
  BTW  stands, so the only handling there is happens before the operation.
  I HAS A divisor ITZ 0
  I HAS A answer ITZ "refused"
  DIFFRINT divisor AN 0
  O RLY?
    YA RLY
      answer R QUOSHUNT OF 10 AN divisor
  OIC
  I IZ report YR 14 AN YR BOTH SAEM answer AN "refused" AN YR "a guard goes before the operation, because nothing catches" MKAY

  BTW  gotchas

  BTW  The hour this saves: arithmetic casts a YARN to a NUMBR without being
  BTW  asked, and comparison does not. The same two values answer differently
  BTW  depending on which one you use.
  I HAS A added ITZ SUM OF 1 AN "3"
  I IZ report YR 15 AN YR BOTH OF BOTH SAEM added AN 4 AN DIFFRINT "3" AN 3 AN YR "arithmetic casts a string, comparison does not" MKAY
KTHXBYE
