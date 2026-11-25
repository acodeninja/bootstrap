# Pace

Work out a running pace: a distance and a time in, minutes per kilometre out. Then try to
add the distance to the time, and watch it fail to compile.

## What it teaches

That a number can carry what it measures. A unit is part of the type, dividing metres by
seconds gives a type nobody declared, and adding metres to seconds is a type error rather
than a wrong answer — all with no run-time representation at all, so the safety is free.

It is the smallest feature in this repo that prevents a whole class of real bug, and the
only one here that would have caught the Mars Climate Orbiter. Thirty minutes.

## Where it sits

Step 3 on `fsharp`. It assumes FizzBuzz, and leads to
[tennis](tennis.md) and [turnstile](turnstile.md).

## Not available in

Nothing else here has it in the language. `haxe` gets closest with
[abstract types](abstract-types.md), which give one unit its own type but no arithmetic
between units. `ada` has dimensional checking through subtypes and aspects, which is the
nearest full relative.

## Source

Written for this repo. Documented at
[F# units of measure](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure).
