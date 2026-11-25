%% The module name must equal the filename here too. The _tests suffix is the
%% convention eunit looks for when asked to test a module: given a module M it
%% also runs M_tests, which is why this file needs no registration anywhere.
-module({{PROJECT_SNAKE}}_tests).

%% This include does two jobs. It defines the ?assert macros used below, and it
%% exports every function in this module whose name ends in _test -- so there is
%% no -export list here, and a test is found purely by being named that way.
-include_lib("eunit/include/eunit.hrl").

%% The _test suffix is the registration. The rest of the name is the test name,
%% and since Erlang function names are atoms with no spaces it is written with
%% underscores and reads as closely to a sentence as it can.
%%
%% ?assertEqual takes expected first and actual second. It is a macro rather
%% than a function, so on failure it prints the expression it was handed as well
%% as the two values -- which a plain comparison could not do.
%%
%% Both strings are binaries, written << >>, because that is what greet/1 takes
%% and returns. Dropping the << >> would compare a binary against a list of
%% integers, which never matches however much the two look alike when printed.
a_greeting_addresses_the_name_it_is_given_test() ->
    ?assertEqual(<<"Hello, world!">>, {{PROJECT_SNAKE}}:greet(<<"world">>)).
