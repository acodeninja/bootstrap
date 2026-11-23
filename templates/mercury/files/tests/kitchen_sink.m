% Fifteen passing assertions: the toolbox for solving a kata in Mercury.
%
% Every assertion is a semidet goal handed to tap.ok, which is the shape the
% language pushes you into: a check succeeds or it fails, and the mode system
% makes you say which. Where Prolog leaves that to the search and ASP leaves
% it to the solver, here it is a declaration the compiler checks before the
% program runs at all.
%
% The types and helper predicates the sections lean on are at the foot of the
% file, because Mercury has no way to put either inside a clause.
:- module kitchen_sink.
:- interface.

:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.

:- import_module int.
:- import_module list.
:- import_module map.
:- import_module maybe.
:- import_module pair.
:- import_module set.
:- import_module solutions.
:- import_module string.
:- import_module tap.

main(!IO) :-
    tap.plan(15, Tap0, !IO),
    assertions(Tap0, Tap, !IO),
    tap.done(Tap, !IO).

% !Tap is sugar for the pair of arguments the declaration spells out: the
% count before the call and the count after it. The assertions live here
% rather than in main because a state variable has to be introduced by a
% clause head.
:- pred assertions(tap::in, tap::out, io::di, io::uo) is det.

assertions(!Tap, !IO) :-
    % collections

    tap.ok(((pred) is semidet :-
        Items = [1, 2],

        Extended = Items ++ [3],

        Extended = [1, 2, 3],
        list.length(Extended) = 3,
        list.index0(Extended, 1, 2)
    ), "a list keeps what you put in it, in order", !Tap, !IO),

    tap.ok(((pred) is semidet :-
        Counts = map.from_assoc_list(["a" - 2, "b" - 1]),

        map.search(Counts, "b", 1),
        map.count(Counts) = 2,
        not map.contains(Counts, "z")
    ), "a map answers for a key it holds and fails for one it does not",
        !Tap, !IO),

    tap.ok(((pred) is semidet :-
        Letters = set.list_to_set(["a", "b", "a"]),

        set.count(Letters) = 2,
        set.contains(Letters, "a"),
        not set.contains(Letters, "z")
    ), "a set drops the duplicate it was given", !Tap, !IO),

    % strings

    tap.ok(((pred) is semidet :-
        Parts = string.words("one two three"),

        Parts = ["one", "two", "three"],
        string.join_list("-", Parts) = "one-two-three"
    ), "a string splits into words and joins back up", !Tap, !IO),

    tap.ok(((pred) is semidet :-
        string.between("abcdef", 0, 3) = "abc",
        string.length("abcdef") = 6,
        string.index("abcdef", 4, 'e')
    ), "a slice of a string counts from zero", !Tap, !IO),

    % Mercury has no variadic call, so format's arguments arrive in a list
    % whose elements are tagged with their type: s for a string, i for an int,
    % f for a float, c for a character.
    tap.ok(((pred) is semidet :-
        string.format("%s x%d", [s("item"), i(2)]) = "item x2",
        string.strip("  padded  ") = "padded"
    ), "a format string takes its arguments in a list tagged by type",
        !Tap, !IO),

    % types and branching

    tap.ok(((pred) is semidet :-
        Record = point(1, 2),

        Record ^ across = 1,
        (Record ^ up := 5) = point(1, 5)
    ), "a discriminated union with named fields is the record type", !Tap, !IO),

    % The three kinds of predicate, which is the declaration no other logic
    % language here makes: det succeeds exactly once, semidet once or not at
    % all, multi and nondet any number of times. Getting one wrong is a
    % compile error rather than a surprise at run time.
    tap.ok(((pred) is semidet :-
        classify(-1, Label),
        Label = "below",

        small(4),
        not small(40),

        solutions(digit) = [1, 2, 3]
    ), "det, semidet and nondet are three different kinds of predicate",
        !Tap, !IO),

    % turn/1 covers all four constructors, so the compiler proves it det. Drop
    % a clause and it becomes semidet, and a function is det by definition --
    % so the file stops compiling rather than quietly having no answer for
    % west.
    tap.ok(((pred) is semidet :-
        turn(north) = east,
        turn(west) = north,

        Wrapped = ( if turn(east) = south then "wraps" else "stops" ),
        Wrapped = "wraps"
    ), "a function over every constructor of a type is deterministic",
        !Tap, !IO),

    % iteration

    tap.ok(((pred) is semidet :-
        int.fold_up(
            (pred(N::in, Acc0::in, Acc::out) is det :- Acc = Acc0 ++ [N * N]),
            1, 4, [], Squares),

        Squares = [1, 4, 9, 16]
    ), "a counted loop is a fold over the range with the index as an argument",
        !Tap, !IO),

    tap.ok(((pred) is semidet :-
        pair_sums([1, 2, 3, 4], Sums),

        Sums = [3, 5, 7],
        pair_sums([], [])
    ), "walking a list two items at a time is a recursive predicate",
        !Tap, !IO),

    % functions

    tap.ok(((pred) is semidet :-
        list.map(doubled, [1, 2, 3]) = [2, 4, 6],
        list.filter(small, [4, 40, 7]) = [4, 7]
    ), "a function and a semidet predicate are both passed by name",
        !Tap, !IO),

    % The accumulator is the operation's second argument, so foldl with a
    % non-commutative one comes out backwards and foldr does not.
    tap.ok(((pred) is semidet :-
        list.foldl(int.plus, [1, 2, 3, 4], 0) = 10,
        list.foldl(string.append, ["a", "b", "c"], "") = "cba",
        list.foldr(string.append, ["a", "b", "c"], "") = "abc"
    ), "folding a list to one value takes an operation and a starting value",
        !Tap, !IO),

    % errors

    % Mercury has exceptions, thrown with exception.throw and caught with
    % exception.try, and they are for a contract the caller broke. An input
    % that might simply be wrong comes back as maybe_error instead: the
    % refusal then has a type, so the compiler makes the caller take it apart.
    tap.ok(((pred) is semidet :-
        percentage("40") = ok(40),

        percentage("140") = error(Reason),
        string.prefix(Reason, "not a percentage")
    ), "a refusal arrives as a value the caller has to take apart", !Tap, !IO),

    % gotchas

    % classify's second argument is `out`, so this call looks like the Prolog
    % one and compiles: Mercury rewrites it as a fresh variable plus a
    % unification afterwards, which is called an implied mode. What it quietly
    % changes is the determinism, because that unification can fail -- so the
    % call is semidet, and the identical line inside a det predicate is
    % rejected with "Declared `det', inferred `semidet'". The surprise is
    % never the mode; it is where the mode lands.
    tap.ok(((pred) is semidet :-
        classify(0, "zero")
    ), "a bound argument in an out slot turns a det call semidet", !Tap, !IO).

% The types and helpers the sections above lean on.

:- type point ---> point(across :: int, up :: int).

:- type direction ---> north ; east ; south ; west.

:- func turn(direction) = direction.

turn(north) = east.
turn(east) = south.
turn(south) = west.
turn(west) = north.

:- pred classify(int::in, string::out) is det.

classify(N, Label) :-
    ( if N < 0 then
        Label = "below"
    else if N = 0 then
        Label = "zero"
    else
        Label = "above"
    ).

:- pred small(int::in) is semidet.

small(N) :-
    N < 10.

:- pred digit(int::out) is multi.

digit(1).
digit(2).
digit(3).

% Three clauses covering every shape a list can take, which is what makes this
% det: empty, one item, and two or more.
:- pred pair_sums(list(int)::in, list(int)::out) is det.

pair_sums([], []).
pair_sums([_], []).
pair_sums([First, Second | Rest], [Sum | Sums]) :-
    Sum = First + Second,
    pair_sums([Second | Rest], Sums).

:- func doubled(int) = int.

doubled(N) = N * 2.

:- func percentage(string) = maybe_error(int).

percentage(Text) =
    ( if string.to_int(Text, N), N >= 0, N =< 100 then
        ok(N)
    else
        error("not a percentage: " ++ Text)
    ).
