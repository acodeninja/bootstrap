# Katas

A kata is a programming exercise you work through to learn something other than the
answer. This directory holds two things: **a course for each of the 64 templates**, and an
index of every kata the sources below carry, so a course is a path through a catalogue
rather than a list somebody had to invent.

Twenty-one katas have a brief here. The rest are in [the catalogue](#the-catalogue) with
their sources, which is all a kata needs — a brief exists where a course sends somebody.

Briefs restate the problem and say what it teaches. **None of them contains a solution or
a hint past that**, for the reason
[kitchen-sink.md](../kitchen-sink.md#why-not-ship-a-kata) already gives for not shipping a
solved kata: handing over the answer to an exercise somebody was about to do is a bad
trade.

## How a course is built

Four rules, and they are what make 64 courses read as one system.

1. **Step 1 is always [Hello, World](hello-world.md).** It tests the toolchain, not the
   reader: build, run, output, and where the suite lives.
2. **Step 2 is always [FizzBuzz](fizzbuzz.md).** The first loop, branch, division and
   string output — and the first test the reader writes rather than reads. That last part
   is why it is not skippable on the fourteen rows whose runner is hand-rolled TAP instead
   of a framework: learning to add an assertion is the first real skill there.
3. **Steps 3 to 5 introduce one new capability class each**, in the order the language
   makes them available.
4. **A course stops where the language stops.** No step needs a primitive the language
   lacks, which is why some courses are four steps and two are three. The reason is in
   each brief, under *Not available in*.

A course is three to five katas because that is a week of evenings, not a syllabus. When
it runs out, the catalogue is right there.

## The courses

Every course starts [Hello, World](hello-world.md) → [FizzBuzz](fizzbuzz.md). This table
is what comes after.

| id | track | then |
| -- | ----- | ---- |
| `ada` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `arm32` | Constrained | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `asp` | Declarative | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `ats` | Proof and effects | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `bash` | Text processing | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) |
| `basic` | Constrained | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) → [bowling](bowling.md) |
| `befunge` | Playfield | [langtons-ant](langtons-ant.md) |
| `bqn` | Array and numeric | [bowling](bowling.md) → [game-of-life](game-of-life.md) |
| `c` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `clojure` | Lisp | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `cobol` | Constrained | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) → [bowling](bowling.md) |
| `commonlisp` | Lisp | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `cpp` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `csharp` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `d` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `dart` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `elixir` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `elm` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `erlang` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `flix` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `forth` | Constrained | [leap-years](leap-years.md) → [rpn-calculator](rpn-calculator.md) |
| `fortran` | Array and numeric | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `fsharp` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `gleam` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `go` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `groovy` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `haskell` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `haxe` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `intercal` | Playfield | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `java` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `javascript` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `julia` | Array and numeric | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `koka` | Proof and effects | [roman-numerals](roman-numerals.md) → [turnstile](turnstile.md) |
| `kotlin` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `lean` | Proof and effects | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `lolcode` | Constrained | [leap-years](leap-years.md) → [roman-numerals](roman-numerals.md) |
| `lua` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `mercury` | Declarative | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `nim` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `objc` | Message passing | [roman-numerals](roman-numerals.md) → [tennis](tennis.md) → [video-store](video-store.md) |
| `ocaml` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `octave` | Array and numeric | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `pascal` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |
| `perl` | Text processing | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `php` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `pony` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `powershell` | Text processing | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `prolog` | Declarative | [turnstile](turnstile.md) → [eight-queens](eight-queens.md) |
| `python` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `qsharp` | Proof and effects | [bowling](bowling.md) → [turnstile](turnstile.md) |
| `r` | Array and numeric | [bowling](bowling.md) → [game-of-life](game-of-life.md) → [diamond](diamond.md) |
| `racket` | Lisp | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `raku` | Text processing | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) → [diamond](diamond.md) |
| `ruby` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `rust` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `scala` | Pattern matching | [word-wrap](word-wrap.md) → [tennis](tennis.md) → [turnstile](turnstile.md) |
| `scheme` | Lisp | [word-wrap](word-wrap.md) → [roman-numerals](roman-numerals.md) → [test-framework](test-framework.md) |
| `smalltalk` | Message passing | [roman-numerals](roman-numerals.md) → [tennis](tennis.md) → [test-framework](test-framework.md) |
| `sql` | Declarative | [bowling](bowling.md) → [turnstile](turnstile.md) → [test-framework](test-framework.md) |
| `swift` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `tcl` | Text processing | [word-wrap](word-wrap.md) → [string-calculator](string-calculator.md) |
| `typescript` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `visualbasic` | Mainstream | [roman-numerals](roman-numerals.md) → [bowling](bowling.md) → [mars-rover](mars-rover.md) |
| `zig` | Systems | [roman-numerals](roman-numerals.md) → [number-to-lcd](number-to-lcd.md) → [mars-rover](mars-rover.md) |

Each generated project carries its own course in its `README.md`, so nobody has to come
back here to find it. This table is the place to see all 64 at once.

## Why these tracks

Eleven tracks, and three of them exist only because following the sources out of the Made
Tech list widened the pool:

- **Game of Life** is the array-language kata. Every cell is the same arithmetic over its
  neighbours, which is the one problem shape `bqn`, `octave`, `r`, `julia` and `fortran`
  are actually built for.
- **Eight Queens** is what `prolog`, `mercury` and `asp` exist to do. Writing down what a
  legal board is and letting the solver find the boards is the entire argument for having
  a logic language, and nothing on the original twelve asks for it.
- **Leap years** needs no strings and no collections, which is exactly the position
  `basic`, `lolcode`, `arm32`, `intercal`, `lean` and `ats` are in. It is the only step 3
  in the catalogue with no missing-primitive caveat at all.

Three single-row deviations earn the same note. `forth` ends on
[RPN calculator](rpn-calculator.md), because the kata is a stack machine and so is the
language. `befunge` does [Langton's Ant](langtons-ant.md), because a 2D ant on a grid is
the one thing a 2D playfield is better at than anything else here. `smalltalk` ends on
[Test framework](test-framework.md), because SUnit is where every runner in
[languages.md](../languages.md) descends from.

## What a language cannot do

Four missing primitives decide every *Not available in* section, and each one is asserted
in the template's own suite rather than claimed here:

| Wall | Blocks | Rows |
| ---- | ------ | ---- |
| no strings | word-wrap, number-to-lcd, wordle, diamond, string-calculator | `intercal`, `befunge`, `lolcode`, `qsharp`, `asp` |
| no first-class functions | test-framework | `befunge`, `lolcode`, `basic`, `intercal`, `asp` |
| nothing catches a failure | test-framework | `qsharp`, `lolcode`, `befunge`, `intercal`, `arm32` |
| no polymorphism | video-store, tennis-refactoring | `sql`, `asp`, `bqn`, `befunge`, `intercal`, `lolcode`, `basic`, `forth`, `arm32`, `qsharp` |

`asp` is the one row that is not a general-purpose language at all: clingo grounds a
finite program, so unbounded iteration and arbitrary-length output are not expressible,
and building a string means leaving for a Lua `@`-term. The consequence inverts what you
would expect — ARM32 assembly can do Roman numerals and ASP cannot.

[Snake](snake.md) is blocked everywhere, by the harness rather than by a language:
[kitchen-sink.md](../kitchen-sink.md) keeps I/O out of every template on purpose, so
nothing here has an input or render path. Two catalogue katas are out for the same reason:
[Ohce](https://kata-log.rocks/ohce-kata) reads from stdin, and
[Anagram](https://codingdojo.org/kata/Anagram/) needs a dictionary file.

## The sources

Six, each reached by following a citation rather than picked by us. The first is where
this repo has always pointed; the next three are catalogues; the last two are single-kata
sources the Made Tech pages name.

| Source | Carries |
| ------ | ------- |
| [Made Tech](https://learn.madetech.com/technology/katas/) | The twelve this repo linked before this directory existed |
| [Coding Dojo](https://codingdojo.org/kata/) | 61 katas, cited by five of those twelve |
| [Kata-Log](https://kata-log.rocks) | 31 katas with difficulty tags, cited by Mars Rover |
| [Emily Bache](https://github.com/emilybache) | 28 kata repositories, cited by Tennis Refactoring |
| [Clean Coders](https://cleancoders.com) | Cited by Video Store |
| [Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch) | Cited by Test Framework |

**Two sources agreeing is a fact worth recording, not a duplicate to hide.** Video Store
is Coding Dojo's Movie Rental, is Emily Bache's Theatrical Players, is chapter 1 of
Fowler's *Refactoring* — one kata, four citations. The catalogue below is deduplicated by
problem, and every row lists each source that carries it.

Starting code for the refactoring katas is **linked, never vendored**. Those repositories
carry their own licences, and [template-contract.md](../template-contract.md) already sets
the bar for third-party code here: a link clears it and a copy opens a question.

## The catalogue

103 katas. The twenty-one with a brief are the ones a course uses; the rest are here with
their sources, which is what you need to pick one up.

| Kata | Brief | Sources |
| ---- | ----- | ------- |
| Anagram | — | [Coding Dojo](https://codingdojo.org/kata/Anagram/) |
| Args | — | [Coding Dojo](https://codingdojo.org/kata/Args/) |
| Bank OCR | — | [Coding Dojo](https://codingdojo.org/kata/BankOCR/) |
| Banking | — | [Kata-Log](https://kata-log.rocks/banking-kata) |
| Birthday Greetings | — | [Coding Dojo](https://codingdojo.org/kata/birthday-greetings/) |
| Bowling | [bowling](bowling.md) | [Made Tech](https://learn.madetech.com/technology/katas/bowling/) · [Coding Dojo](https://codingdojo.org/kata/Bowling/) · [Kata-Log](https://kata-log.rocks/bowling-game-kata) |
| Brainfuck | — | [Coding Dojo](https://codingdojo.org/kata/Brainfuck/) |
| BugsZero | — | [Kata-Log](https://kata-log.rocks/bugs-zero-kata) |
| CalcStats | — | [Bache](https://github.com/emilybache/CalcStats-TestDesign-Kata) |
| Cash Machine | — | [Bache](https://github.com/emilybache/CashMachine-Refactoring-Kata) |
| Christmas Delivery | — | [Coding Dojo](https://codingdojo.org/kata/christmas-delivery/) |
| Christmas Lights | — | [Kata-Log](https://kata-log.rocks/christmas-lights-kata) |
| Clarify Exception | — | [Bache](https://github.com/emilybache/Clarify-Exception-Refactoring-Kata) |
| Clock-in | — | [Kata-Log](https://kata-log.rocks/clock-in-kata) |
| Code Cracker | — | [Coding Dojo](https://codingdojo.org/kata/CodeCracker/) |
| Configure Your Own Wardrobe | — | [Kata-Log](https://kata-log.rocks/configure-wardrobe-kata) |
| CQRS Booking | — | [Coding Dojo](https://codingdojo.org/kata/CQRS_Booking/) |
| Cupcake | — | [Coding Dojo](https://codingdojo.org/kata/cupcake/) |
| Depth First Search | — | [Coding Dojo](https://codingdojo.org/kata/DepthFirstSearch/) |
| Diagram Printer | — | [Bache](https://github.com/emilybache/DiagramPrinter-Refactoring-Kata) |
| Diamond | [diamond](diamond.md) | [Coding Dojo](https://codingdojo.org/kata/Diamond/) · [Bache](https://github.com/emilybache/DiamondKata) |
| Dictionary Replacer | — | [Coding Dojo](https://codingdojo.org/kata/DictionaryReplacer/) |
| Discount Applier | — | [Bache](https://github.com/emilybache/DiscountApplier-TestDesign-Kata) |
| Eight Queens | [eight-queens](eight-queens.md) | [Coding Dojo](https://codingdojo.org/kata/eight-queens/) |
| Elephant Carpaccio | — | [Coding Dojo](https://codingdojo.org/kata/elephant-carpaccio/) · [Kata-Log](https://kata-log.rocks/elephant-carpaccio) |
| Employee Report | — | [Coding Dojo](https://codingdojo.org/kata/Employee-Report/) |
| Encode | — | [Bache](https://github.com/emilybache/Encode-TestDesign-Kata) |
| Enterprise Phonebook | — | [Bache](https://github.com/emilybache/EnterprisePhonebook-TestDesign-Kata) |
| FizzBuzz | [fizzbuzz](fizzbuzz.md) | [Coding Dojo](https://codingdojo.org/kata/FizzBuzz/) · [Kata-Log](https://kata-log.rocks/fizz-buzz-kata) · [Bache](https://github.com/emilybache/FizzBuzz-Refactoring-Kata) |
| FooBarQix | — | [Coding Dojo](https://codingdojo.org/kata/FooBarQix/) |
| Game of Life | [game-of-life](game-of-life.md) | [Coding Dojo](https://codingdojo.org/kata/GameOfLife/) · [Kata-Log](https://kata-log.rocks/game-of-life-kata) |
| Garden Catalogue | — | [Bache](https://github.com/emilybache/GardenCatalogue-TestDesign-Kata) |
| Gilded Rose | — | [Coding Dojo](https://codingdojo.org/kata/gilded-rose/) · [Kata-Log](https://kata-log.rocks/gilded-rose-kata) · [Bache](https://github.com/emilybache/GildedRose-Refactoring-Kata) |
| Gossiping Bus Drivers | — | [Kata-Log](https://kata-log.rocks/gossiping-bus-drivers-kata) |
| Greed | — | [Coding Dojo](https://codingdojo.org/kata/Greed/) |
| Hello, World | [hello-world](hello-world.md) | [Coding Dojo](https://codingdojo.org/kata/Hello/) |
| HTML Converter | — | [Bache](https://github.com/emilybache/HtmlConverter-TestDesign-Kata) |
| Ice Cream Forecasting | — | [Bache](https://github.com/emilybache/IceCreamForecasting-Refactoring-Kata) |
| JEE Web Authentication | — | [Coding Dojo](https://codingdojo.org/kata/JEEWebAuthentication/) |
| Lags | — | [Coding Dojo](https://codingdojo.org/kata/Lags/) |
| Langton's Ant | [langtons-ant](langtons-ant.md) | [Coding Dojo](https://codingdojo.org/kata/LangtonAnt/) |
| Leap Years | [leap-years](leap-years.md) | [Coding Dojo](https://codingdojo.org/kata/LeapYears/) |
| Lift | — | [Kata-Log](https://kata-log.rocks/lift-kata) · [Bache](https://github.com/emilybache/Lift-Kata) |
| Manhattan Distance | — | [Coding Dojo](https://codingdojo.org/kata/manhattan-distance/) · [Kata-Log](https://kata-log.rocks/manhattan-distance-kata) |
| Markov Chain | — | [Coding Dojo](https://codingdojo.org/kata/MarkovChain/) |
| Mars Rover | [mars-rover](mars-rover.md) | [Made Tech](https://learn.madetech.com/technology/katas/mars-rover/) · [Coding Dojo](https://codingdojo.org/kata/mars-rover/) · [Kata-Log](https://kata-log.rocks/mars-rover-kata) |
| Mastermind | — | [Coding Dojo](https://codingdojo.org/kata/Mastermind/) |
| Mathematical AST | — | [Coding Dojo](https://codingdojo.org/kata/mathematical-ast/) |
| Memory Map | — | [Bache](https://github.com/emilybache/MemoryMap-TestDesign-Kata) |
| Minesweeper | — | [Coding Dojo](https://codingdojo.org/kata/Minesweeper/) |
| Nearest Color | — | [Coding Dojo](https://codingdojo.org/kata/NearestColor/) |
| Necklace | — | [Bache](https://github.com/emilybache/Necklace-Refactoring-Kata) |
| Nim | — | [Coding Dojo](https://codingdojo.org/kata/Nim/) |
| Number to LCD | [number-to-lcd](number-to-lcd.md) | [Made Tech](https://learn.madetech.com/technology/katas/number-to-lcd/) · [Coding Dojo](https://codingdojo.org/kata/NumberToLCD/) |
| Numbers in Words | — | [Coding Dojo](https://codingdojo.org/kata/NumbersInWords/) |
| Ohce | — | [Kata-Log](https://kata-log.rocks/ohce-kata) |
| ORM | — | [Coding Dojo](https://codingdojo.org/kata/orm/) |
| Overtime Calculation | — | [Bache](https://github.com/emilybache/OvertimeCalculation-Refactoring-Kata) |
| PacMan | — | [Coding Dojo](https://codingdojo.org/kata/PacMan/) |
| Pagination Seven | — | [Coding Dojo](https://codingdojo.org/kata/PaginationSeven/) |
| Parallel Change | — | [Kata-Log](https://kata-log.rocks/parallel-change-kata) |
| Parrot | — | [Bache](https://github.com/emilybache/Parrot-Refactoring-Kata) |
| Pension Contribution | — | [Bache](https://github.com/emilybache/PensionContribution-TestDesign-Kata) |
| Phone Numbers | — | [Bache](https://github.com/emilybache/Phone-Numbers-Kata) |
| Pizza Maker | — | [Coding Dojo](https://codingdojo.org/kata/pizza-maker/) |
| Poker Hands | — | [Coding Dojo](https://codingdojo.org/kata/PokerHands/) |
| Potter | — | [Coding Dojo](https://codingdojo.org/kata/Potter/) |
| Quote of the Day | — | [Coding Dojo](https://codingdojo.org/kata/QotdCgi/) |
| Race Car — Leaderboard | — | [Kata-Log](https://kata-log.rocks/race-car-katas-leaderboard) |
| Race Car — Telemetry | — | [Kata-Log](https://kata-log.rocks/race-car-katas-telemetry) |
| Range | — | [Coding Dojo](https://codingdojo.org/kata/Range/) |
| Reversi | — | [Coding Dojo](https://codingdojo.org/kata/Reversi/) |
| Roman Calculator | — | [Coding Dojo](https://codingdojo.org/kata/RomanCalculator/) |
| Roman Numerals | [roman-numerals](roman-numerals.md) | [Made Tech](https://learn.madetech.com/technology/katas/roman-numerals/) · [Coding Dojo](https://codingdojo.org/kata/RomanNumerals/) · [Kata-Log](https://kata-log.rocks/roman-numerals-kata) |
| RPG Combat | — | [Bache](https://github.com/emilybache/RPG-Combat-Approval-Kata) |
| RPN Calculator | [rpn-calculator](rpn-calculator.md) | [Coding Dojo](https://codingdojo.org/kata/RPN/) |
| RSA | — | [Coding Dojo](https://codingdojo.org/kata/rsa/) |
| Score Keeper | — | [Kata-Log](https://kata-log.rocks/score-keeper-kata) |
| Sing a Song | — | [Kata-Log](https://kata-log.rocks/sing-a-song-kata) |
| Snake | [snake](snake.md) | [Made Tech](https://learn.madetech.com/technology/katas/snake/) |
| Social Network | — | [Coding Dojo](https://codingdojo.org/kata/social-network/) · [Kata-Log](https://kata-log.rocks/social-network-kata) |
| Strange Characters | — | [Bache](https://github.com/emilybache/StrangeCharacters-Refactoring-Kata) |
| String Calculator | [string-calculator](string-calculator.md) | [Coding Dojo](https://codingdojo.org/kata/StringCalculator/) · [Kata-Log](https://kata-log.rocks/string-calculator-kata) |
| Sudoku | — | [Coding Dojo](https://codingdojo.org/kata/sudoku/) |
| Supermarket Receipt | — | [Bache](https://github.com/emilybache/SupermarketReceipt-Refactoring-Kata) |
| Task List | — | [Kata-Log](https://kata-log.rocks/task-list-kata) |
| Tell Don't Ask | — | [Kata-Log](https://kata-log.rocks/tell-dont-ask-kata) |
| Tennis | [tennis](tennis.md) | [Made Tech](https://learn.madetech.com/technology/katas/tennis/) · [Coding Dojo](https://codingdojo.org/kata/Tennis/) · [Kata-Log](https://kata-log.rocks/tennis-kata) |
| Tennis Refactoring | [tennis-refactoring](tennis-refactoring.md) | [Made Tech](https://learn.madetech.com/technology/katas/tennis-refactoring/) · [Bache](https://github.com/emilybache/Tennis-Refactoring-Kata) |
| Test Framework | [test-framework](test-framework.md) | [Made Tech](https://learn.madetech.com/technology/katas/test-framework/) · [Destroy All Software](https://www.destroyallsoftware.com/screencasts/catalog/building-rspec-from-scratch) |
| Texas Hold'em | — | [Coding Dojo](https://codingdojo.org/kata/TexasHoldEm/) |
| Tic Tac Toe | — | [Coding Dojo](https://codingdojo.org/kata/tic-tac-toe/) · [Kata-Log](https://kata-log.rocks/tic-tac-toe-kata) |
| Trading Card Game | — | [Coding Dojo](https://codingdojo.org/kata/TradingCardGame/) |
| Train Reservation | — | [Bache](https://github.com/emilybache/KataTrainReservation) |
| Trip Service | — | [Coding Dojo](https://codingdojo.org/kata/TripService/) · [Kata-Log](https://kata-log.rocks/trip-service-kata) |
| Turnstile | [turnstile](turnstile.md) | [Made Tech](https://learn.madetech.com/technology/katas/turnstile/) |
| Ugly Trivia Game | — | [Kata-Log](https://kata-log.rocks/ugly-trivia-kata) |
| Unusual Spending | — | [Kata-Log](https://kata-log.rocks/unusual-spending-kata) |
| Video Store | [video-store](video-store.md) | [Made Tech](https://learn.madetech.com/technology/katas/video-store/) · [Coding Dojo](https://codingdojo.org/kata/movie-rental/) · [Bache](https://github.com/emilybache/Theatrical-Players-Refactoring-Kata) · [Clean Coders](https://cleancoders.com) |
| Wallet | — | [Coding Dojo](https://codingdojo.org/kata/Wallet/) |
| Word Wrap | [word-wrap](word-wrap.md) | [Made Tech](https://learn.madetech.com/technology/katas/word-wrap/) · [Coding Dojo](https://codingdojo.org/kata/WordWrap/) |
| Wordle | [wordle](wordle.md) | [Made Tech](https://learn.madetech.com/technology/katas/wordle/) |
| Yatzy | — | [Coding Dojo](https://codingdojo.org/kata/Yahtzee/) · [Kata-Log](https://kata-log.rocks/yahtzee-kata) · [Bache](https://github.com/emilybache/Yatzy-Refactoring-Kata) |
