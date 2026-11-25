%% A module declaration, and the name here must equal the filename without the
%% extension -- rename one and you rename both. Attributes like this start with a
%% hyphen and end with a full stop, as every form in Erlang does.
-module({{PROJECT_SNAKE}}).

%% This is the whole of visibility: a function is reachable from outside the
%% module if it appears here and not otherwise. The /1 is its arity, which is
%% part of a function's identity -- greet/1 and greet/2 are two different
%% functions that happen to share a name.
-export([greet/1]).

%% A spec is for the dialyzer rather than the compiler: nothing here is checked
%% when the module is built, and `make lint` runs the dialyzer, which does check
%% it. Changing the function without changing this line fails lint, not the test.
-spec greet(binary()) -> binary().

%% A clause ends with a full stop, and a function may have several clauses chosen
%% by pattern -- this one has a single clause with a plain variable, which matches
%% anything. Variables are capitalised; a lower-case word is an atom, which is a
%% constant naming itself.
greet(Name) ->
    %% << >> is the bit-syntax constructor and this is a binary, which is what
    %% you want text to be. A double-quoted literal in Erlang is a *list of
    %% integers* -- "Hi" is [72, 105] -- so the /binary on Name is what says
    %% "splice these bytes in" rather than treating it as one number.
    <<"Hello, ", Name/binary, "!">>.
