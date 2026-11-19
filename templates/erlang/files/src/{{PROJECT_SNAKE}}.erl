-module({{PROJECT_SNAKE}}).

-export([greet/1]).

-spec greet(binary()) -> binary().
greet(Name) ->
    <<"Hello, ", Name/binary, "!">>.
