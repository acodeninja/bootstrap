%% Fifteen passing tests: the toolbox for solving a kata in Prolog.

:- begin_tests(kitchen_sink).

:- use_module(library(apply)).
:- use_module(library(debug)).
:- use_module(library(lists)).
:- use_module(library(ordsets)).
:- use_module(library(pairs)).

% collections

test('a list keeps what you put in it, in order') :-
    Items = [a, b],

    append(Items, [c], Extended),

    assertion(Extended == [a, b, c]),
    assertion(length(Extended, 3)),
    assertion(nth0(1, Extended, b)).

test('a list of pairs gives every item a key and a value') :-
    pairs_keys_values(Counts, [a, b], [2, 1]),

    memberchk(b-Found, Counts),

    assertion(Counts == [a-2, b-1]),
    assertion(Found == 1),
    assertion(\+ memberchk(z-_, Counts)).

test('a sorted set discards duplicates') :-
    list_to_ord_set([a, b, a], Letters),

    assertion(Letters == [a, b]),
    assertion(ord_memberchk(a, Letters)),
    assertion(\+ ord_memberchk(z, Letters)).

% strings

test('a string splits into parts and joins back up') :-
    Text = "one two three",

    split_string(Text, " ", "", Parts),
    atomic_list_concat(Parts, '-', Joined),

    assertion(Parts == ["one", "two", "three"]),
    assertion(Joined == 'one-two-three').

test('a slice of a string counts from zero') :-
    Text = "abcdef",

    sub_string(Text, 0, 3, _, Prefix),
    sub_string(Text, 4, 2, 0, Suffix),

    assertion(Prefix == "abc"),
    assertion(Suffix == "ef"),
    assertion(string_chars(Text, [a, b, c, d, e, f])).

test('text is built up by formatting rather than by appending') :-
    Name = world,

    format(string(Line), "~w x~w", [Name, 2]),
    normalize_space(string(Trimmed), "  padded  "),

    assertion(Line == "world x2"),
    assertion(Trimmed == "padded"),
    assertion(string_concat("ab", "cd", "abcd")).

% types and branching

test('a compound term groups related fields under one name') :-
    Record = point(1, 2),

    Record =.. Parts,

    assertion(Parts == [point, 1, 2]),
    assertion(arg(1, Record, 1)),
    assertion(functor(Record, point, 2)).

next_state(locked, open).
next_state(open, locked).

test('a fixed set of named states is one fact per state') :-
    % Nothing checks the set is complete. A state nobody wrote a fact for has
    % no next state, and the caller gets a failure rather than an error.
    assertion(next_state(locked, open)),
    assertion(next_state(open, locked)),
    assertion(\+ next_state(broken, _)).

describe(N, Label) :-
    (   N < 0
    ->  Label = negative
    ;   N =:= 0
    ->  Label = zero
    ;   Label = positive
    ).

test('a branch produces a value instead of setting one') :-
    assertion(describe(-1, negative)),
    assertion(describe(0, zero)),
    assertion(describe(1, positive)).

% iteration

test('a range is walked by between/3 and gathered by findall/3') :-
    findall(N, between(1, 4, N), Numbers),

    assertion(Numbers == [1, 2, 3, 4]),
    assertion(forall(member(N, Numbers), N > 0)),
    assertion(\+ between(1, 4, 9)).

pair_sums([], []).
pair_sums([_], []).
pair_sums([First, Second | Rest], [Sum | Sums]) :-
    Sum is First + Second,
    pair_sums([Second | Rest], Sums).

test('walking a list two items at a time is a recursive predicate') :-
    Values = [1, 2, 3, 4],

    pair_sums(Values, Sums),

    assertion(Sums == [3, 5, 7]),
    assertion(pair_sums([], [])).

% functions

scale(N, Doubled) :-
    Doubled is N * 2.

scale(N, Factor, Scaled) :-
    Scaled is N * Factor.

test('the same name at two arities is two unrelated predicates') :-
    assertion(scale(3, 6)),
    assertion(scale(3, 5, 15)),
    assertion(current_predicate(scale/2)),
    assertion(\+ current_predicate(scale/4)).

test('a predicate is handed to another by name and completed with call/N') :-
    Values = [1, 2, 3, 4],

    maplist(scale, Values, Doubled),
    foldl(plus, Values, 0, Total),
    findall(Tenth, (member(V, Values), call(scale, V, 10, Tenth)), Tenfold),

    assertion(Doubled == [2, 4, 6, 8]),
    assertion(Total == 10),
    assertion(Tenfold == [10, 20, 30, 40]).

% errors

percentage(Input, Input) :-
    integer(Input),
    between(0, 100, Input).

test('a predicate with no answer fails rather than raising') :-
    % Failure is the whole idiom, so a test asserts a refusal with \+. A throw
    % means the caller broke the contract, not that the input was invalid.
    assertion(percentage(40, 40)),
    assertion(\+ percentage(140, _)),
    assertion(\+ percentage(half, _)),
    assertion(catch(must_be(integer, half), error(type_error(integer, half), _), true)).

% gotchas

test('a sum written with = stays a term and is never added up') :-
    Unevaluated = 1 + 1,

    Evaluated is 1 + 1,

    assertion(Unevaluated == 1 + 1),
    assertion(Unevaluated \== 2),
    assertion(Evaluated == 2).

:- end_tests(kitchen_sink).
