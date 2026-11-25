% Nothing names this file. make test hands every tests/*.lp to clingo in turn
% and reads its exit status, so a test file is found by existing and deleting
% one is safe. Run the suite with make test.
%
% The include pulls in the program under test. It is textual -- there is no
% module system -- and the full stop at the end is part of the directive.
#include "../src/{{PROJECT_SNAKE}}.lp".

% An assertion is an integrity constraint: a rule with no head, which says the
% body must never all hold. So a test is written as the thing that must not
% happen, and clingo reports no answer set at all when one is violated. That
% exit status is what the runner reads.
%
% There is no name string anywhere -- this runner cannot give you one, so the
% comment above each constraint is the only place the intent can live.

% a person is greeted
:- not greeted(world).

% and nobody else is
:- greeted(a).
