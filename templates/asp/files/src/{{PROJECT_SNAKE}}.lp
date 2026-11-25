% {{PROJECT_NAME}}
%
% An ASP program is facts and rules together, so the data lives here with the
% rules that close over it. Splitting them means a second file and an #include,
% not a module system.
%
% Comments are a percent sign to end of line, and %* *% is the block form. A
% comment cannot sit inside a rule before the full stop that ends it.

% The greeter, and it is not a function, because there are none. Nothing here is
% called and nothing returns: a program is a set of facts and rules, and running
% it produces an answer set -- the collection of atoms that must be true if the
% rules hold. So the nearest thing to greeting somebody is to derive an atom
% saying they have been greeted.
%
% A fact is a rule with no body and it ends with a full stop. Lower-case words
% are constants, so `world` is a value; capitals are variables, which appear
% only in rules.
person(world).

% A rule, read right to left: greeted(X) holds for any X for which person(X)
% holds. The :- is the implication and the head is on the left.
%
% There is no string here and there could not be one. A string in ASP is a
% single opaque term -- it compares and it orders, and nothing opens it -- so
% building the text "Hello, world!" would mean leaving the language for a Lua
% term. That is why the course here takes Leap years rather than FizzBuzz.
greeted(X) :- person(X).

% The recursive rule puts reaches/2 first in its own body. An SLD-resolution
% engine would follow that into itself forever; grounding unfolds it instead,
% so left recursion is ordinary here.
step(a, b).
step(b, c).

reaches(X, Y) :- step(X, Y).
reaches(X, Z) :- reaches(X, Y), step(Y, Z).
