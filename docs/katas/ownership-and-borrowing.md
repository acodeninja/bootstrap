# Tally

Count how many times each word appears in a list of lines. Then answer two questions from
that one tally: which word is commonest, and how many words there were altogether.

The counting is ten minutes. The lesson is the second sentence: three functions want the
same tally, and the compiler decides which may borrow it, which needs it mutably, and
which is allowed to consume it. Get that wrong and nothing runs — which is the point,
because in most languages getting it wrong means two callers quietly sharing one thing.

## What it teaches

Ownership, borrowing, and the difference between `&T`, `&mut T` and `T` in a signature.
A signature in Rust says who owns what, and this is the smallest problem where that is a
decision rather than a formality. Also the first real meeting with lifetimes, which are
inferred here and so stay invisible if you let them.

## Where it sits

Step 3 on `rust`. It assumes FizzBuzz.

## Not available in

Nothing else here has it. Every other garbage-collected row lets three callers share one
map without comment, which is why this kata belongs to Rust alone.

## Source

Written for this repo. No catalogue carries it, because a catalogue is written about
problems and this is about a language. The feature is documented in
[The Book, chapter 4](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html).
