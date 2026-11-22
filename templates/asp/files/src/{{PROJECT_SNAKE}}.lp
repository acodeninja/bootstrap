% {{PROJECT_NAME}}
%
% An ASP program is facts and rules together, so the data lives here with the
% rules that close over it. Splitting them means a second file and an #include,
% not a module system.

step(a, b).
step(b, c).

% The recursive rule puts reaches/2 first in its own body. An SLD-resolution
% engine would follow that into itself forever; grounding unfolds it instead,
% so left recursion is ordinary here.
reaches(X, Y) :- step(X, Y).
reaches(X, Z) :- reaches(X, Y), step(Y, Z).
