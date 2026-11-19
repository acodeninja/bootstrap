use std::collections::{HashMap, HashSet};

// collections

#[test]
fn a_list_keeps_what_you_put_in_it_in_order() {
    let mut items = vec!["a", "b"];

    items.push("c");

    assert_eq!(items, vec!["a", "b", "c"]);
    assert_eq!(items.len(), 3);
    assert_eq!(&items[1..3], ["b", "c"]);
}

#[test]
fn a_lookup_for_a_key_that_is_not_there_comes_back_empty() {
    let mut counts = HashMap::new();
    counts.insert("a", 2);
    counts.insert("b", 1);

    assert_eq!(counts.get("a"), Some(&2));
    assert_eq!(counts.get("z"), None);
    assert_eq!(counts.get("z").copied().unwrap_or(0), 0);
}

#[test]
fn a_set_discards_duplicates() {
    let letters: HashSet<char> = ['a', 'b', 'a'].into_iter().collect();

    assert_eq!(letters.len(), 2);
    assert!(letters.contains(&'a'));
    assert!(!letters.contains(&'z'));
}

// strings

#[test]
fn a_string_splits_into_parts_and_joins_back_up() {
    let words: Vec<&str> = "one two three".split(' ').collect();

    assert_eq!(words, vec!["one", "two", "three"]);
    assert_eq!(words.join("-"), "one-two-three");
}

#[test]
fn a_slice_of_a_string_counts_from_zero() {
    let text = "abcdef";

    assert_eq!(&text[0..1], "a");
    assert_eq!(&text[0..3], "abc");
    assert_eq!(&text[text.len() - 2..], "ef");
}

#[test]
fn text_can_be_built_up_by_formatting() {
    let name = "world";
    let count = 2;

    assert_eq!(format!("{name} x{count}"), "world x2");
    assert_eq!("ab".repeat(3), "ababab");
    assert_eq!("  padded  ".trim(), "padded");
}

// types and branching

#[derive(Debug, PartialEq, Clone)]
struct Point {
    x: i32,
    y: i32,
}

#[test]
fn a_struct_groups_related_fields_under_one_name() {
    let point = Point { x: 1, y: 2 };

    let moved = Point {
        x: 5,
        ..point.clone()
    };

    assert_eq!(moved, Point { x: 5, y: 2 });
    assert_eq!(point, Point { x: 1, y: 2 });
}

#[derive(Debug, PartialEq)]
enum Lock {
    Locked,
    Open,
}

fn toggle(state: &Lock) -> Lock {
    match state {
        Lock::Locked => Lock::Open,
        Lock::Open => Lock::Locked,
    }
}

#[test]
fn a_fixed_set_of_named_states_must_be_matched_exhaustively() {
    // Dropping a variant from toggle's match stops the crate compiling.
    // That check is the reason to reach for an enum over a pair of strings.
    assert_eq!(toggle(&Lock::Locked), Lock::Open);
    assert_eq!(toggle(&Lock::Open), Lock::Locked);
}

#[test]
fn a_branch_can_produce_a_value_instead_of_setting_one() {
    let describe = |n: i32| {
        if n < 0 {
            "negative"
        } else if n == 0 {
            "zero"
        } else {
            "positive"
        }
    };

    assert_eq!(describe(-1), "negative");
    assert_eq!(describe(0), "zero");
    assert_eq!(describe(1), "positive");
}

// iteration

#[test]
fn a_loop_can_read_both_the_position_and_the_item() {
    let mut seen = Vec::new();

    for (index, item) in ["a", "b"].iter().enumerate() {
        seen.push(format!("{index}:{item}"));
    }

    assert_eq!(seen, vec!["0:a", "1:b"]);
}

#[test]
fn a_sequence_can_be_walked_two_items_at_a_time() {
    let values = [1, 2, 3, 4];

    let pairs: Vec<i32> = values.windows(2).map(|pair| pair[0] + pair[1]).collect();

    assert_eq!(pairs, vec![3, 5, 7]);
}

// functions

fn double(n: i32) -> i32 {
    n * 2
}

#[test]
fn a_function_can_be_handed_to_another_function() {
    let values = [1, 2, 3];

    let doubled: Vec<i32> = values.iter().map(|&n| double(n)).collect();
    let big: Vec<i32> = values.into_iter().filter(|&n| n > 1).collect();

    assert_eq!(doubled, vec![2, 4, 6]);
    assert_eq!(big, vec![2, 3]);
}

#[test]
fn a_list_can_be_folded_down_to_a_single_value() {
    let values = [1, 2, 3, 4];

    let total = values.iter().fold(0, |sum, n| sum + n);

    assert_eq!(total, 10);
}

// errors

#[derive(Debug, PartialEq)]
enum PercentageError {
    OutOfRange,
}

impl std::fmt::Display for PercentageError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "not a percentage")
    }
}

fn parse_percentage(input: &str) -> Result<u8, PercentageError> {
    let value: i32 = input.parse().map_err(|_| PercentageError::OutOfRange)?;

    if value < 0 || value > 100 {
        return Err(PercentageError::OutOfRange);
    }

    Ok(value as u8)
}

#[test]
fn an_invalid_input_is_refused_rather_than_guessed_at() {
    assert_eq!(parse_percentage("40"), Ok(40));
    assert_eq!(parse_percentage("140"), Err(PercentageError::OutOfRange));
    assert_eq!(
        parse_percentage("half").unwrap_err().to_string(),
        "not a percentage"
    );
}

// gotchas

#[test]
fn a_strings_length_counts_bytes_not_characters() {
    // Slicing by a byte index that lands inside "é" panics at runtime;
    // count chars first when a string might hold more than ASCII.
    let text = "café";

    assert_eq!(text.len(), 5);
    assert_eq!(text.chars().count(), 4);
}
