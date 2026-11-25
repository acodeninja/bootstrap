%% A directive: the :- prefix means "run this now, while loading" rather than
%% "here is a clause". The module name is greeter whatever the file is called --
%% this one is named after the project -- and the list is the export list, which
%% is the whole of visibility.
%%
%% greet/2 is the name and the arity together, which is how a predicate is
%% identified: greet/2 and greet/3 are different predicates sharing a word.
:- module(greeter, [greet/2]).

%% A predicate, not a function. It takes two arguments and returns nothing: the
%% answer comes back through Greeting, which the caller passes in unbound. That
%% is why the arity is 2 for something that looks like it takes one argument,
%% and it is the single biggest adjustment arriving from anywhere else.
%%
%% Capitalised words are variables and lower-case words are atoms -- constants
%% that name themselves. So Name and Greeting are holes to be filled, and
%% `greeter` above is a value.
%%
%% The clause reads "greet(Name, Greeting) holds if ...", and the full stop at
%% the end is part of the syntax rather than punctuation.
greet(Name, Greeting) :-
    %% atomic_list_concat/2 joins a list of atoms into one. It also runs
    %% backwards -- given the result it can produce the parts -- which is the
    %% other half of what "predicate rather than function" buys you.
    atomic_list_concat(['Hello, ', Name, '!'], Greeting).
