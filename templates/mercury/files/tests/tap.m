% TAP in fifty lines, because Mercury ships no test framework. A test is a
% module under tests/ with main/2; it prints a plan and one line per
% assertion, and the runner in the image compares the two.
%
% This module declares no main/2, so the runner treats it as a library the
% tests import rather than a test of its own.
:- module tap.
:- interface.

:- import_module io.

% Abstract, so a test can only move the count along by calling ok.
:- type tap.

:- pred plan(int::in, tap::out, io::di, io::uo) is det.

% The assertion arrives as a goal rather than a boolean, which is the shape
% the language pushes you into: a check either succeeds or fails. `semidet` in
% the mode is what says so, and the compiler holds every caller to it -- a
% goal that could succeed twice is nondet and will not go in this slot.
:- pred ok((pred)::in((pred) is semidet), string::in, tap::in, tap::out,
    io::di, io::uo) is det.

:- pred done(tap::in, io::di, io::uo) is det.

:- implementation.

:- import_module int.
:- import_module list.
:- import_module string.

:- type tap ---> counts(ran :: int, failed :: int).

plan(Total, counts(0, 0), !IO) :-
    io.format("1..%d\n", [i(Total)], !IO).

ok(Goal, Name, counts(Ran0, Failed0), counts(Ran, Failed), !IO) :-
    Ran = Ran0 + 1,
    ( if Goal then
        Failed = Failed0,
        io.format("ok %d - %s\n", [i(Ran), s(Name)], !IO)
    else
        Failed = Failed0 + 1,
        io.format("not ok %d - %s\n", [i(Ran), s(Name)], !IO)
    ).

done(counts(Ran, Failed), !IO) :-
    ( if Failed > 0 then
        io.format("# %d of %d assertions failed\n", [i(Failed), i(Ran)], !IO),
        io.set_exit_status(1, !IO)
    else
        true
    ).
