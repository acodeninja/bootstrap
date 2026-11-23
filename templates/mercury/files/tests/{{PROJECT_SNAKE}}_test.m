:- module {{PROJECT_SNAKE}}_test.
:- interface.

:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.

:- import_module {{PROJECT_SNAKE}}.
:- import_module tap.

% The tap value is threaded by hand here, one version per assertion, because
% two assertions do not need the sugar. !IO is that same pair written the
% short way: every io call takes the state before and produces the state
% after, and the compiler's unique modes are what stop you reusing one.
main(!IO) :-
    tap.plan(2, Tap0, !IO),

    tap.ok(((pred) is semidet :-
        greeting("world") = "Hello, world!"
    ), "a greeting addresses the name it is given", Tap0, Tap1, !IO),

    tap.ok(((pred) is semidet :-
        shouted("world", Shout),
        Shout = "HELLO, WORLD!"
    ), "a shouted greeting is the same greeting in upper case", Tap1, Tap, !IO),

    tap.done(Tap, !IO).
