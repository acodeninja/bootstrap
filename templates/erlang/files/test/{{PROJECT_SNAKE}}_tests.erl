-module({{PROJECT_SNAKE}}_tests).

-include_lib("eunit/include/eunit.hrl").

a_greeting_addresses_the_name_it_is_given_test() ->
    ?assertEqual(<<"Hello, world!">>, {{PROJECT_SNAKE}}:greet(<<"world">>)).
