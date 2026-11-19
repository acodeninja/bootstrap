-module(kitchen_sink_tests).

-include_lib("eunit/include/eunit.hrl").

-record(point, {x, y}).

%% collections

a_list_keeps_what_you_append_in_order_test() ->
    Items = [a, b] ++ [c],

    ?assertEqual([a, b, c], Items),
    ?assertEqual(3, length(Items)),
    ?assertEqual([b, c], lists:sublist(Items, 2, 2)).

a_map_lookup_for_a_missing_key_comes_back_as_error_test() ->
    Counts = #{a => 2, b => 1},

    ?assertEqual(2, maps:get(a, Counts)),
    ?assertEqual(error, maps:find(z, Counts)),
    ?assertEqual(0, maps:get(z, Counts, 0)).

a_set_discards_duplicates_and_answers_membership_test() ->
    Letters = sets:from_list([a, b, a]),

    ?assertEqual(2, sets:size(Letters)),
    ?assert(sets:is_element(a, Letters)),
    ?assertNot(sets:is_element(z, Letters)).

%% strings

a_binary_splits_into_parts_you_walk_one_at_a_time_test() ->
    Parts = string:split(<<"one two three">>, <<" ">>, all),

    ?assertEqual([<<"one">>, <<"two">>, <<"three">>], Parts).

a_slice_of_a_binary_counts_from_zero_test() ->
    Text = <<"abcdef">>,

    ?assertEqual($a, binary:at(Text, 0)),
    ?assertEqual(<<"abc">>, string:slice(Text, 0, 3)),
    ?assertEqual(<<"ef">>, string:slice(Text, 4)).

text_is_built_by_formatting_into_a_binary_test() ->
    Line = iolist_to_binary(io_lib:format("~s x~p", [<<"world">>, 2])),

    ?assertEqual(<<"world x2">>, Line),
    ?assertEqual(<<"abcabc">>, binary:copy(<<"abc">>, 2)),
    ?assertEqual(<<"padded">>, string:trim(<<"  padded  ">>)).

%% types and branching

assigning_a_record_copies_it_test() ->
    Point = #point{x = 1, y = 2},

    Moved = Point#point{x = 5},

    ?assertEqual(5, Moved#point.x),
    ?assertEqual(1, Point#point.x).

a_case_over_a_fixed_set_of_atoms_covers_every_state_test() ->
    Locked =
        case locked of
            locked -> open;
            open -> locked
        end,
    Open =
        case open of
            locked -> open;
            open -> locked
        end,

    ?assertEqual(open, Locked),
    ?assertEqual(locked, Open).

a_branch_produces_a_value_instead_of_setting_one_test() ->
    Labels = lists:map(
        fun(N) ->
            if
                N < 0 -> negative;
                N =:= 0 -> zero;
                true -> positive
            end
        end,
        [-1, 0, 1]
    ),

    ?assertEqual([negative, zero, positive], Labels).

%% iteration

lists_enumerate_pairs_each_item_with_its_position_test() ->
    Pairs = lists:enumerate([a, b, c]),

    ?assertEqual([{1, a}, {2, b}, {3, c}], Pairs),
    ?assertEqual(b, element(2, lists:keyfind(2, 1, Pairs))).

a_sequence_can_be_walked_two_items_at_a_time_test() ->
    Values = [1, 2, 3, 4],

    Sums = [A + B || {A, B} <- lists:zip(lists:droplast(Values), tl(Values))],

    ?assertEqual([3, 5, 7], Sums).

%% functions

a_function_can_be_handed_to_another_function_test() ->
    Double = fun(N) -> N * 2 end,

    Doubled = lists:map(Double, [1, 2, 3]),

    ?assertEqual([2, 4, 6], Doubled).

a_list_is_folded_down_to_a_single_value_test() ->
    Total = lists:foldl(fun(N, Acc) -> N + Acc end, 0, [1, 2, 3, 4]),

    ?assertEqual(10, Total).

%% errors

parse_percentage(Input) ->
    case string:to_integer(Input) of
        {error, no_integer} ->
            {error, not_a_percentage};
        {Value, ""} when Value >= 0, Value =< 100 ->
            {ok, Value};
        {_Value, _Rest} ->
            {error, not_a_percentage}
    end.

an_invalid_input_comes_back_as_a_tagged_error_tuple_test() ->
    ?assertEqual({ok, 40}, parse_percentage("40")),
    ?assertEqual({error, not_a_percentage}, parse_percentage("half")),
    ?assertEqual({error, not_a_percentage}, parse_percentage("140")).

%% gotchas

a_double_quoted_string_is_a_list_of_integers_test() ->
    % "Hi" is sugar for [72, 105], not a binary — io:format("~p") on a list of
    % small integers prints it back as a string, which hides the difference.
    Chars = "Hi",

    ?assertEqual([72, 105], Chars),
    ?assert(is_list(Chars)),
    ?assertNot(is_binary(Chars)).
