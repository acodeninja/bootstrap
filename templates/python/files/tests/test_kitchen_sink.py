from dataclasses import dataclass, replace
from enum import Enum
from functools import reduce
from itertools import pairwise

import pytest

# collections


def test_a_list_keeps_what_you_put_in_it_in_order():
    items = ["a", "b"]

    items.append("c")

    assert items == ["a", "b", "c"]
    assert len(items) == 3
    assert items[1:3] == ["b", "c"]


def test_a_lookup_for_a_key_that_is_not_there_comes_back_empty():
    counts = {"a": 2, "b": 1}

    assert counts["a"] == 2
    assert counts.get("z") is None
    assert counts.get("z", 0) == 0


def test_a_set_discards_duplicates():
    items = ["a", "b", "a"]

    letters = set(items)

    assert len(letters) == 2
    assert "a" in letters
    assert "z" not in letters


# strings


def test_a_string_splits_into_parts_and_joins_back_up():
    text = "one two three"

    words = text.split(" ")

    assert words == ["one", "two", "three"]
    assert "-".join(words) == "one-two-three"


def test_a_slice_of_a_string_counts_from_zero():
    text = "abcdef"

    assert text[0] == "a"
    assert text[0:3] == "abc"
    assert text[-2:] == "ef"


def test_text_can_be_built_up_by_interpolation():
    name = "world"
    count = 2

    line = f"{name} x{count}"

    assert line == "world x2"
    assert "ab" * 3 == "ababab"
    assert "  padded  ".strip() == "padded"


# types and branching


def test_a_dataclass_groups_related_fields_under_one_name():
    @dataclass
    class Point:
        x: int
        y: int

    point = Point(1, 2)

    moved = replace(point, x=5)

    assert moved == Point(5, 2)
    assert point == Point(1, 2)


def test_a_fixed_set_of_named_states_can_be_matched_one_by_one():
    # match has no exhaustiveness check: add a State member without a
    # matching case and toggle returns None instead of failing.
    class State(Enum):
        LOCKED = "locked"
        OPEN = "open"

    def toggle(state):
        match state:
            case State.LOCKED:
                return State.OPEN
            case State.OPEN:
                return State.LOCKED

    assert toggle(State.LOCKED) is State.OPEN
    assert toggle(State.OPEN) is State.LOCKED


def test_a_branch_can_produce_a_value_instead_of_setting_one():
    def describe(n):
        return "negative" if n < 0 else "zero" if n == 0 else "positive"

    assert describe(-1) == "negative"
    assert describe(0) == "zero"
    assert describe(1) == "positive"


# iteration


def test_a_loop_can_read_both_the_position_and_the_item():
    items = ["a", "b"]
    seen = []

    for index, item in enumerate(items):
        seen.append(f"{index}:{item}")

    assert seen == ["0:a", "1:b"]


def test_a_sequence_can_be_walked_two_items_at_a_time():
    values = [1, 2, 3, 4]

    pairs = [a + b for a, b in pairwise(values)]

    assert pairs == [3, 5, 7]


# functions


def test_a_function_can_be_handed_to_another_function():
    def double(n):
        return n * 2

    values = [1, 2, 3]

    doubled = list(map(double, values))
    big = list(filter(lambda n: n > 1, values))

    assert doubled == [2, 4, 6]
    assert big == [2, 3]


def test_a_list_can_be_folded_down_to_a_single_value():
    values = [1, 2, 3, 4]

    total = reduce(lambda acc, n: acc + n, values, 0)

    assert total == 10


# errors


def test_an_invalid_input_is_refused_rather_than_guessed_at():
    class PercentageError(ValueError):
        pass

    def parse_percentage(text):
        value = int(text)

        if value < 0 or value > 100:
            raise PercentageError(f"not a percentage: {text!r}")

        return value

    assert parse_percentage("40") == 40

    with pytest.raises(PercentageError):
        parse_percentage("140")

    with pytest.raises(ValueError):
        parse_percentage("half")


# gotchas


def test_a_mutable_default_argument_is_shared_across_calls():
    def append_item(item, items=[]):
        items.append(item)
        return items

    first = append_item("a")
    second = append_item("b")

    assert first is second
    assert second == ["a", "b"]
