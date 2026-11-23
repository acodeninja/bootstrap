% Modules for {{PROJECT_NAME}}. A module's name is its filename without the
% `.m`, so renaming this file means renaming the first line with it.
%
% The interface is what other modules can see, and a declaration there is
% three facts rather than one: the types of the arguments, the mode each one
% arrives or leaves in, and how many times the call can succeed. A function is
% det with every argument `in` by default, which is why `greeting` needs no
% mode line and `shouted` does.
:- module {{PROJECT_SNAKE}}.
:- interface.

:- func greeting(string) = string.

:- pred shouted(string::in, string::out) is det.

:- implementation.

:- import_module string.

greeting(Name) = "Hello, " ++ Name ++ "!".

shouted(Name, Shout) :-
    Shout = string.to_upper(greeting(Name)).
