import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

pub type Pair {
  Pair(first: Int, second: Int)
}

pub type State {
  Locked
  Open
}

pub type ParseError {
  NotANumber(String)
  OutOfRange(Int)
}

// collections

pub fn a_list_grows_at_the_front_and_keeps_its_order_test() {
  let items = ["b", "c"]

  let extended = ["a", ..items]

  assert extended == ["a", "b", "c"]
  assert list.length(extended) == 3
  assert list.take(extended, 2) == ["a", "b"]
}

pub fn a_lookup_for_a_key_that_is_not_there_comes_back_as_an_error_test() {
  let counts = dict.from_list([#("a", 2), #("b", 1)])

  assert dict.get(counts, "a") == Ok(2)
  assert dict.get(counts, "z") == Error(Nil)
  assert result.unwrap(dict.get(counts, "z"), 0) == 0
}

pub fn a_set_keeps_one_copy_of_each_member_test() {
  let members = set.from_list(["a", "b", "a"])

  assert set.size(members) == 2
  assert set.contains(members, "a")
  assert set.contains(members, "z") == False
}

// strings

pub fn a_string_splits_into_parts_and_joins_back_up_test() {
  let words = string.split("one two three", " ")

  assert words == ["one", "two", "three"]
  assert string.join(words, "-") == "one-two-three"
}

pub fn a_slice_of_a_string_counts_graphemes_from_zero_test() {
  let text = "abcdef"

  assert string.slice(text, 0, 3) == "abc"
  assert string.slice(text, -2, 2) == "ef"
  assert string.first(text) == Ok("a")
}

pub fn there_is_no_interpolation_so_text_is_joined_piece_by_piece_test() {
  let count = 2

  let label = "world x" <> int.to_string(count)

  assert label == "world x2"
  assert string.repeat("ab", 3) == "ababab"
  assert string.trim("  padded  ") == "padded"
}

// types and branching

pub fn a_record_groups_related_fields_under_one_name_test() {
  let record = Pair(first: 1, second: 2)

  let changed = Pair(..record, first: 5)

  assert changed == Pair(first: 5, second: 2)
  assert changed.first == 5
  assert record.first == 1
}

pub fn every_variant_of_a_fixed_set_of_states_has_to_be_matched_test() {
  let advance = fn(state) {
    case state {
      Locked -> Open
      Open -> Locked
    }
  }

  assert advance(Locked) == Open
  assert advance(Open) == Locked
}

pub fn a_case_expression_produces_a_value_instead_of_setting_one_test() {
  let describe = fn(value) {
    case value {
      value if value < 0 -> "negative"
      0 -> "zero"
      _ -> "positive"
    }
  }

  assert describe(-1) == "negative"
  assert describe(0) == "zero"
  assert describe(1) == "positive"
}

// iteration

pub fn with_no_loop_the_position_comes_from_the_call_that_walks_the_list_test() {
  let items = ["a", "b"]

  let labelled =
    list.index_map(items, fn(item, index) {
      int.to_string(index) <> ":" <> item
    })

  assert labelled == ["0:a", "1:b"]
  assert list.index_fold(items, "", fn(acc, item, _) { acc <> item }) == "ab"
}

pub fn a_sequence_is_read_with_lookahead_by_recursing_over_its_pairs_test() {
  let values = [1, 2, 3, 4]

  let sums = sum_adjacent(values)

  assert sums == [3, 5, 7]
  assert list.window_by_2(values) == [#(1, 2), #(2, 3), #(3, 4)]
}

// functions

pub fn a_function_can_be_handed_to_another_function_test() {
  let double = fn(value) { value * 2 }

  let doubled = list.map([1, 2, 3], double)
  let big = list.filter([1, 2, 3], fn(value) { value > 1 })

  assert doubled == [2, 4, 6]
  assert big == [2, 3]
}

pub fn a_list_folds_down_to_a_single_value_test() {
  let values = [1, 2, 3, 4]

  let total = list.fold(values, 0, fn(acc, value) { acc + value })

  assert total == 10
}

// errors

pub fn an_invalid_input_comes_back_as_an_error_rather_than_a_guess_test() {
  let accepted = parse_percentage("40")
  let out_of_range = parse_percentage("140")
  let unparseable = parse_percentage("half")

  assert accepted == Ok(40)
  assert out_of_range == Error(OutOfRange(140))
  assert unparseable == Error(NotANumber("half"))
}

// gotchas

pub fn dividing_an_integer_by_zero_gives_zero_rather_than_failing_test() {
  let divisor = 0

  assert 5 / divisor == 0
  assert 5 % divisor == 0
  assert int.divide(5, divisor) == Error(Nil)
}

fn sum_adjacent(values: List(Int)) -> List(Int) {
  case values {
    [first, second, ..rest] -> [
      first + second,
      ..sum_adjacent([second, ..rest])
    ]
    _ -> []
  }
}

fn parse_percentage(input: String) -> Result(Int, ParseError) {
  case int.parse(input) {
    Error(Nil) -> Error(NotANumber(input))
    Ok(value) ->
      case value >= 0 && value <= 100 {
        True -> Ok(value)
        False -> Error(OutOfRange(value))
      }
  }
}
