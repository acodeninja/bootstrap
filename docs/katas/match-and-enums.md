# HTTP status

Model a handful of HTTP statuses as an enum with methods on it: the numeric code, the
reason phrase, and whether the status counts as an error. Then write a function that
classifies an arbitrary integer into a category, using `match (true)` rather than a chain
of `elseif`.

## What it teaches

That PHP has had a real enum since 8.1 and a real expression-level branch since 8.0, and
that the combination changes how the language reads. `match` is an expression, so every arm
produces a value; it compares with `===` rather than `==`, so none of the language's
famous coercion applies; and it throws when nothing matches instead of falling through to
nothing.

`match (true)` is the idiom worth stealing. It turns a ladder of conditions into a table,
which is the shape the eye wants, and it is the nearest thing PHP has to a guard clause.

## Where it sits

Step 3 on `php`. It assumes FizzBuzz, and leads to
[roman numerals](roman-numerals.md) and [bowling](bowling.md).

## Not available in

The whole functional half of this repo has had this for decades. The reason it is PHP step
3 anyway is that most PHP in the world predates it: knowing that `match` exists, is
strict, and is total is the single most useful modern-PHP fact there is.

## Source

Written for this repo. Documented at
[PHP: match](https://www.php.net/manual/en/control-structures.match.php) and
[PHP: Enumerations](https://www.php.net/manual/en/language.enumerations.php).
