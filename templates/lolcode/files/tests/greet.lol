HAI 1.2
  BTW  Nothing names this file. make test splices src ahead of every tests/*.lol
  BTW  and runs the result, reading the TAP it prints -- so a test file is found
  BTW  by existing and deleting one is safe. Run the suite with make test.
  BTW
  BTW  The plan has to agree with the number of ok lines below, because nothing
  BTW  counts them for you and the runner checks.
  VISIBLE "1..1"

  BTW  I HAS A declares a variable and ITZ gives it a value. I IZ calls a
  BTW  function, YR introduces each argument, and MKAY closes the call -- the
  BTW  same MKAY that closed SMOOSH in the greeter, because it closes any
  BTW  argument list.
  I HAS A greeting ITZ I IZ greet YR "world" MKAY

  BTW  BOTH SAEM is equality, and it leaves its answer in IT -- the implicit
  BTW  variable that O RLY? then branches on. So the comparison and the branch
  BTW  are two statements rather than one expression.
  BTW
  BTW  Note which comparison this is: BOTH SAEM does not cast, where arithmetic
  BTW  would. "10" and 10 are not BOTH SAEM, but SUM OF "10" AN 0 is 10.
  BOTH SAEM greeting AN "Hello, world!"
  O RLY?
    BTW  YA RLY is the true arm and NO WAI the false one, and OIC closes the
    BTW  whole thing. There is no assertion function: the TAP line is printed by
    BTW  hand in each arm, which is why the test name appears twice.
    BTW
    BTW  Nothing catches anything in this language -- a division by zero ends
    BTW  the program -- so every refusal is a guard like this one, written
    BTW  before the operation rather than around it.
    YA RLY
      VISIBLE "ok 1 - a greeting addresses the name it is given"
    NO WAI
      VISIBLE "not ok 1 - a greeting addresses the name it is given"
  OIC
KTHXBYE
