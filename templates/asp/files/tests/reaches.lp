#include "../src/{{PROJECT_SNAKE}}.lp".

% a chain of steps is reachable, and reachability does not run backwards
:- not reaches(a, c).
:- reaches(c, a).
