enum State with Eq, ToString {
    case Locked
    case Open
}

enum ParseError with Eq, ToString {
    case NotANumber(String)
    case OutOfRange(Int32)
}

// collections

@Test
def a_list_grows_at_the_front_and_keeps_its_order(): Unit \ Assert =
    let items = List#{"b", "c"};

    let extended = "a" :: items;

    Assert.assertEq(expected = List#{"a", "b", "c"}, extended);
    Assert.assertEq(expected = 3, List.length(extended));
    Assert.assertEq(expected = List#{"a", "b"}, List.take(2, extended))

@Test
def a_lookup_for_a_key_that_is_not_there_comes_back_as_none(): Unit \ Assert =
    let counts = Map#{"a" => 2, "b" => 1};

    Assert.assertEq(expected = Some(2), Map.get("a", counts));
    Assert.assertEq(expected = None, Map.get("z", counts));
    Assert.assertEq(expected = 0, Map.getWithDefault("z", 0, counts))

@Test
def a_set_keeps_one_copy_of_each_member(): Unit \ Assert =
    let members = Set#{"a", "b", "a"};

    Assert.assertEq(expected = 2, Set.size(members));
    Assert.assertTrue(Set.memberOf("a", members));
    Assert.assertFalse(Set.memberOf("z", members))

// strings

@Test
def a_string_splits_into_parts_and_joins_back_up(): Unit \ Assert =
    let words = String.split(regex = " ", "one two three");

    Assert.assertEq(expected = List#{"one", "two", "three"}, words);
    Assert.assertEq(expected = "one-two-three", List.join("-", words))

@Test
def a_slice_of_a_string_counts_from_zero(): Unit \ Assert =
    let text = "abcdef";

    Assert.assertEq(expected = "abc", String.slice(start = 0, end = 3, text));
    Assert.assertEq(expected = 'a', String.charAt(0, text));
    Assert.assertEq(expected = 6, String.length(text))

@Test
def a_string_interpolates_any_value_that_can_print_itself(): Unit \ Assert =
    let count = 2;

    let label = "world x${count}";

    Assert.assertEq(expected = "world x2", label);
    Assert.assertEq(expected = "ababab", String.repeat(3, "ab"));
    Assert.assertEq(expected = "padded", String.trim("  padded  "))

// types and branching

@Test
def a_record_groups_related_fields_under_one_name(): Unit \ Assert =
    let record = {first = 1, second = 2};

    let changed = {first = 5 | record};

    Assert.assertEq(expected = 5, changed#first);
    Assert.assertEq(expected = 2, changed#second);
    Assert.assertEq(expected = 1, record#first)

@Test
def every_variant_of_a_fixed_set_of_states_has_to_be_matched(): Unit \ Assert =
    let advance = state -> match state {
        case State.Locked => State.Open
        case State.Open   => State.Locked
    };

    Assert.assertEq(expected = State.Open, advance(State.Locked));
    Assert.assertEq(expected = State.Locked, advance(State.Open))

@Test
def a_match_expression_produces_a_value_instead_of_setting_one(): Unit \ Assert =
    let describe = value -> match value {
        case v if v < 0 => "negative"
        case 0          => "zero"
        case _          => "positive"
    };

    Assert.assertEq(expected = "negative", describe(-1));
    Assert.assertEq(expected = "zero", describe(0));
    Assert.assertEq(expected = "positive", describe(1))

// iteration

@Test
def the_position_in_a_sequence_comes_from_the_call_that_walks_it(): Unit \ Assert =
    let items = List#{"a", "b", "c"};

    let labelled = List.mapWithIndex((index, item) -> "${index}:${item}", items);
    let pairs = List.zip(items, List.drop(1, items));

    Assert.assertEq(expected = List#{"0:a", "1:b", "2:c"}, labelled);
    Assert.assertEq(expected = List#{("a", "b"), ("b", "c")}, pairs)

@Test
def a_rule_that_refers_to_itself_runs_until_nothing_new_is_derived(): Unit \ Assert =
    let edges = inject List#{(1, 2), (2, 3), (3, 4)} into Edge/2;
    let rules = #{
        Path(x, y) :- Edge(x, y).
        Path(x, z) :- Path(x, y), Edge(y, z).
    };

    let reached = query edges, rules select y from Path(1, y);

    Assert.assertEq(expected = Vector#{2, 3, 4}, reached)

// functions

@Test
def a_function_can_be_handed_to_another_function(): Unit \ Assert =
    let double = value -> value * 2;

    let doubled = List.map(double, List#{1, 2, 3});
    let big = List.filter(value -> value > 1, List#{1, 2, 3});

    Assert.assertEq(expected = List#{2, 4, 6}, doubled);
    Assert.assertEq(expected = List#{2, 3}, big)

@Test
def a_list_folds_down_to_a_single_value(): Unit \ Assert =
    let values = List#{1, 2, 3, 4};

    let total = List.foldLeft((acc, value) -> acc + value, 0, values);

    Assert.assertEq(expected = 10, total)

// errors

@Test
def an_invalid_input_comes_back_as_an_error_rather_than_a_guess(): Unit \ Assert =
    let accepted = parsePercentage("40");
    let outOfRange = parsePercentage("140");
    let unparseable = parsePercentage("half");

    Assert.assertEq(expected = Ok(40), accepted);
    Assert.assertEq(expected = Err(ParseError.OutOfRange(140)), outOfRange);
    Assert.assertEq(expected = Err(ParseError.NotANumber("half")), unparseable)

// gotchas

@Test
def mutation_inside_a_region_leaves_the_function_pure(): Unit \ Assert =
    let values = List#{1, 2, 3};

    Assert.assertEq(expected = 6, sumByMutation(values))

def sumByMutation(values: List[Int32]): Int32 = region rc {
    let total = Ref.fresh(rc, 0);
    List.forEach(value -> Ref.put(Ref.get(total) + value, total), values);
    Ref.get(total)
}

def parsePercentage(input: String): Result[ParseError, Int32] =
    match Int32.fromString(input) {
        case None => Err(ParseError.NotANumber(input))
        case Some(value) =>
            if (value >= 0 and value <= 100)
                Ok(value)
            else
                Err(ParseError.OutOfRange(value))
    }
