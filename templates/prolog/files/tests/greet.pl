:- use_module('../src/{{PROJECT_SNAKE}}').

:- begin_tests(greet).

:- use_module(library(debug)).

test('a greeting addresses the name it is given') :-
    greet(world, Greeting),

    assertion(Greeting == 'Hello, world!').

:- end_tests(greet).
