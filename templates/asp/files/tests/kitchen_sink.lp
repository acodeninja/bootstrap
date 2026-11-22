% Fifteen passing assertions: the toolbox for solving a kata in ASP.
%
% Nothing here is called and nothing returns. The file is one program, the
% facts and rules say what should be true, and each `:- not ...` throws away
% every answer set where it is not. A program with an answer set passed; one
% without it failed, and clingo reports that as exit status 20.
%
% The sentence above each group is the assertion. There is nowhere for clingo
% to name the constraint that fired, because a failing program has no answer
% set to print -- comment them out until it goes green again.

% collections

% a set of facts is the only collection there is, and it holds each term once
letter(a).
letter(b).
letter(a).
:- #count { L : letter(L) } != 2.
:- not letter(a).
:- letter(z).

% a lookup table is a relation, so a missing key is a tuple that is not there
tally(a, 2).
tally(b, 1).
:- not tally(b, 1).
:- tally(z, _).
:- #count { K : tally(K, _) } != 2.

% order has to be carried in an argument, because nothing else remembers it
item(1, red).
item(2, green).
item(3, blue).
:- not item(2, green).
:- #max { P : item(P, _) } != 3.
:- #count { P : item(P, _), P >= 2 } != 2.

% strings

% a string is one opaque term: it compares and it orders, and nothing opens it
word("one").
word("two").
:- not "one" < "two".
:- "one" = one.
:- #count { W : word(W) } != 2.

% text has to be spread across positions before a rule can reach inside it
char(1, o).
char(2, n).
char(3, e).
:- #count { P : char(P, _) } != 3.
:- not char(2, n).
:- #max { P : char(P, _) } != 3.

% building a string means leaving the language for a Lua @-term
#script (lua)
function join(a, b)
  return a.string .. b.string
end
#end.
joined(@join("on", "e")).
:- not joined("one").
:- joined("eon").

% types and branching

% a record is a function term, and a rule body takes it apart by shape
reading(point(2, 5)).
across(X) :- reading(point(X, _)).
:- not across(2).
:- reading(point(5, 2)).

% a constraint is the only thing that notices a state nobody gave a transition
state(locked).
state(open).
turn(locked, open).
turn(open, locked).
covered(S) :- turn(S, _).
:- state(S), not covered(S).
:- not turn(open, locked).

% a branch is one rule per case, and the bodies are what keep them apart
sample(-1).
sample(0).
sample(4).
sign(N, below) :- sample(N), N < 0.
sign(N, zero) :- sample(N), N = 0.
sign(N, above) :- sample(N), N > 0.
:- not sign(-1, below).
:- not sign(0, zero).
:- #count { L : sign(4, L) } != 1.

% iteration

% there is no loop: an interval grounds into one fact per value
tick(1..4).
:- #count { N : tick(N) } != 4.
:- not tick(3).
:- tick(5).

% lookahead is a join between adjacent indices, not a step through a list
value(1, 4).
value(2, 3).
value(3, 2).
window(I, S) :- value(I, A), value(I + 1, B), S = A + B.
:- not window(1, 7).
:- #count { I : window(I, _) } != 2.

% functions

% nothing returns, so an operator is a constant and the answer is an argument
operand(2).
operand(3).
apply(sum, A, B, C) :- operand(A), operand(B), C = A + B.
apply(product, A, B, C) :- operand(A), operand(B), C = A * B.
:- not apply(sum, 2, 3, 5).
:- not apply(product, 2, 3, 6).
:- apply(sum, 2, 3, 6).

% folding is an aggregate, which the solver computes over the whole relation
score(1, 10).
score(2, 20).
score(3, 30).
:- #sum { V,I : score(I, V) } != 60.
:- #min { V,I : score(I, V) } != 10.
:- #max { I : score(I, _) } != 3.

% errors

% nothing is raised: a value that breaks a rule takes the answer set with it
percentage(0..100).
offered(40).
offered(140).
rejected(V) :- offered(V), not percentage(V).
% A real program writes `:- rejected(_).` and gets no answer at all, which is
% the same exit status 20 that make test reports as a failing test.
:- not rejected(140).
:- rejected(40).

% gotchas

% an aggregate adds up element tuples, so two equal values count once until
% something in the tuple tells them apart
entry(1, 4).
entry(2, 4).
entry(3, 2).
:- #sum { V : entry(I, V) } != 6.
:- #sum { V,I : entry(I, V) } != 10.
