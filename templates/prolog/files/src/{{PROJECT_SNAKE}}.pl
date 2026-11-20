:- module(greeter, [greet/2]).

greet(Name, Greeting) :-
    atomic_list_concat(['Hello, ', Name, '!'], Greeting).
