% The module name is the filename again. Nothing names this file beyond that:
% `make test` compiles and runs every tests/*.m that has a main and reads the TAP
% it prints, so a test file is found by existing and deleting one is safe. Run
% the suite with `make test`.
:- module {{PROJECT_SNAKE}}_test.
:- interface.

:- import_module io.

% A test file is a program, and `main` is its entry point. The two io arguments
% are the thing to look at: `di` is destructive input and `uo` is unique output,
% so main consumes the state of the world and produces a new one. That pair is
% how a pure language does I/O, and the compiler's uniqueness checking is what
% stops you holding on to the old state.
:- pred main(io::di, io::uo) is det.

:- implementation.

:- import_module {{PROJECT_SNAKE}}.
% tap.m under tests/ is this project's own TAP vocabulary -- Mercury ships no
% test framework, so plan, ok and done are source you can read.
:- import_module tap.

% The tap value is threaded by hand here, one version per assertion, because
% two assertions do not need the sugar. !IO is that same pair written the
% short way: every io call takes the state before and produces the state
% after, and the compiler's unique modes are what stop you reusing one.
main(!IO) :-
    % The 2 is the number of assertions about to be made, and the runner checks
    % it against the ok lines. Add one and this changes with it.
    tap.plan(2, Tap0, !IO),

    % Each assertion hands `ok` a goal rather than a boolean. `((pred) is
    % semidet :- ...)` is an anonymous predicate declared to succeed at most
    % once, and that determinism is part of its type -- so the thing being
    % asserted is "this goal succeeds", which is what a logic language has
    % instead of a comparison returning true.
    %
    % Note the comma at the end of each goal: it is conjunction, so the body of
    % main is one clause made of several goals, and the full stop at the very
    % end is what closes it.
    tap.ok(((pred) is semidet :-
        greeting("world") = "Hello, world!"
    ), "a greeting addresses the name it is given", Tap0, Tap1, !IO),

    % The predicate version, and it reads differently: `shouted` takes an out
    % argument rather than returning, so the goal is two steps -- make the call,
    % then check what it bound. Shout is bound by the first goal and tested by
    % the second, which is what unification looks like when it is doing work.
    tap.ok(((pred) is semidet :-
        shouted("world", Shout),
        Shout = "HELLO, WORLD!"
    ), "a shouted greeting is the same greeting in upper case", Tap1, Tap, !IO),

    % Prints the summary and sets the exit status.
    tap.done(Tap, !IO).
