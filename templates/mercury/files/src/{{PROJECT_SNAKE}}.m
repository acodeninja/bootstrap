% Modules for {{PROJECT_NAME}}. A module's name is its filename without the
% `.m`, so renaming this file means renaming the first line with it.
%
% Comments are a percent sign to end of line; /* */ is the block form. A percent
% inside a quoted string is literal, and Mercury has no way to put a type or a
% helper predicate inside a clause -- so anything a declaration needs lives at
% the top level, which is why this file is laid out the way it is.
%
% The interface is what other modules can see, and a declaration there is
% three facts rather than one: the types of the arguments, the mode each one
% arrives or leaves in, and how many times the call can succeed. A function is
% det with every argument `in` by default, which is why `greeting` needs no
% mode line and `shouted` does.
:- module {{PROJECT_SNAKE}}.
:- interface.

% A function: arguments in, one value out, and the `= string` says what. Note
% the name is `greeting` rather than `greet`, which is this template keeping a
% function and a predicate side by side so the difference is visible.
:- func greeting(string) = string.

% A predicate, which returns nothing: the answer comes back through an argument.
% `::in` means that argument is bound when the call is made and `::out` means the
% call binds it, and `is det` promises the call succeeds exactly once.
%
% The alternatives to det are the thing to learn here. `semidet` succeeds once or
% fails, `multi` succeeds at least once and possibly more, `nondet` any number of
% times including none. Getting one wrong is a compile error, which is the whole
% difference between this language and Prolog.
:- pred shouted(string::in, string::out) is det.

:- implementation.

% Every standard library module a file uses has to be imported by name. There is
% no implicit prelude beyond the builtins, so a call to string.to_upper without
% this line does not compile.
:- import_module string.

% The function clause. There is no `return`: the value to the right of the `=` is
% the answer, and ++ appends two strings.
greeting(Name) = "Hello, " ++ Name ++ "!".

% The predicate clause, and it reads differently on purpose: `Shout = ...` is not
% an assignment but a unification, binding the out argument the declaration
% promised. The body is a conjunction of goals, and here there is one.
shouted(Name, Shout) :-
    Shout = string.to_upper(greeting(Name)).
