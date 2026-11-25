%% Loading the module under test. use_module/1 takes a path here rather than a
%% module name, because this file is not installed anywhere -- the quotes make it
%% an atom, which is what the path has to be.
:- use_module('../src/{{PROJECT_SNAKE}}').

%% Everything between begin_tests/1 and end_tests/1 belongs to a named unit, and
%% the name has to match at both ends. Nothing lists this file: `make test` loads
%% every tests/*.pl and then calls run_tests/0, which runs whatever got declared
%% -- so a test file is found by existing, and with none loaded run_tests prints
%% "No tests to run" and succeeds. Run the suite with `make test`.
:- begin_tests(greet).

%% assertion/1 lives here. Loading it inside the block rather than at the top is
%% deliberate: it keeps the dependency next to the thing that needs it.
:- use_module(library(debug)).

%% A test is a clause of the predicate test/1, so the name is an argument rather
%% than an identifier -- quoted, it can be a real sentence, and it is what a
%% failure prints.
test('a greeting addresses the name it is given') :-
    %% The call, with Greeting unbound: the answer arrives by being unified into
    %% that variable rather than by being returned. `world` is an atom, which is
    %% what greet/2 concatenates.
    greet(world, Greeting),

    %% Two distinctions in one line. == tests whether two terms are already
    %% identical, where = would *unify* them -- and unifying an unbound variable
    %% always succeeds, so a test written with = would pass whatever greet did.
    %%
    %% assertion/1 throws when its goal fails, and a thrown goal is how a plunit
    %% test fails. Without it the clause would simply fail, which plunit also
    %% reports -- but the exception names the line, and a plain failure does not.
    assertion(Greeting == 'Hello, world!').

:- end_tests(greet).
