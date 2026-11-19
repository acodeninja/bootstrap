# frozen_string_literal: true

require "minitest/autorun"

class KitchenSinkTest < Minitest::Test
  # collections

  def test_an_array_keeps_what_you_push_into_it_in_order
    items = %w[a b]

    items << "c"

    assert_equal %w[a b c], items
    assert_equal 3, items.length
    assert_equal %w[b c], items[1, 2]
  end

  def test_a_hash_lookup_for_a_key_that_is_not_there_comes_back_nil
    counts = { "a" => 2, "b" => 1 }

    assert_equal 2, counts["a"]
    assert_nil counts["z"]
    assert_equal 0, counts.fetch("z", 0)
  end

  def test_a_set_discards_duplicates
    letters = Set.new

    %w[a b a].each { |letter| letters << letter }

    assert_equal 2, letters.size
    assert_includes letters, "a"
    assert_equal %w[a b], letters.to_a
  end

  # strings

  def test_a_string_splits_into_parts_and_joins_back_up
    words = "one two three".split

    assert_equal %w[one two three], words
    assert_equal "one-two-three", words.join("-")
  end

  def test_indexing_a_string_gives_back_a_one_character_string
    text = "abcdef"

    assert_equal "a", text[0]
    assert_equal "abc", text[0, 3]
    assert_equal "ef", text[-2..]
  end

  def test_text_is_built_up_by_interpolation
    name = "world"
    count = 2

    assert_equal "world x2", "#{name} x#{count}"
    assert_equal "ababab", "ab" * 3
    assert_equal "padded", "  padded  ".strip
  end

  # types and branching

  def test_a_data_object_groups_related_fields_and_cannot_be_changed
    point = Data.define(:x, :y).new(x: 1, y: 2)

    moved = point.with(x: 5)

    assert_equal 5, moved.x
    assert_equal 1, point.x
    assert_predicate point, :frozen?
  end

  def test_a_pattern_match_over_a_fixed_set_of_states_raises_when_nothing_fits
    state = :locked
    unknown = :broken

    next_state = case state
                 in :locked then :open
                 in :open then :locked
                 end

    assert_equal :open, next_state
    assert_raises(NoMatchingPatternError) do
      case unknown
      in :locked then :open
      in :open then :locked
      end
    end
  end

  def test_a_branch_produces_a_value_instead_of_setting_one
    labels = [-1, 0, 1].map do |n|
      if n.negative?
        "negative"
      elsif n.zero?
        "zero"
      else
        "positive"
      end
    end

    assert_equal %w[negative zero positive], labels
  end

  # iteration

  def test_a_loop_can_read_both_the_position_and_the_item
    seen = []

    %w[a b].each_with_index { |item, index| seen << "#{index}:#{item}" }

    assert_equal ["0:a", "1:b"], seen
  end

  def test_a_sequence_can_be_walked_two_items_at_a_time
    values = [1, 2, 3, 4]

    pairs = values.each_cons(2).map { |first, second| first + second }

    assert_equal [3, 5, 7], pairs
  end

  # functions

  def test_a_function_can_be_handed_to_another_function
    double = ->(n) { n * 2 }

    doubled = [1, 2, 3].map(&double)
    lengths = %w[a bb].map(&:length)

    assert_equal [2, 4, 6], doubled
    assert_equal [1, 2], lengths
  end

  def test_a_list_is_folded_down_to_a_single_value_by_reduce
    values = [1, 2, 3, 4]

    total = values.reduce(0) { |sum, n| sum + n }

    assert_equal 10, total
    assert_equal 24, values.reduce(:*)
  end

  # errors

  class NotAPercentage < StandardError; end

  def parse_percentage(input)
    value = Integer(input, exception: false)
    raise NotAPercentage, "not a percentage: #{input}" unless value&.between?(0, 100)

    value
  end

  def test_an_invalid_input_is_refused_rather_than_guessed_at
    assert_equal 40, parse_percentage("40")
    assert_raises(NotAPercentage) { parse_percentage("half") }

    error = assert_raises(NotAPercentage) { parse_percentage("140") }

    assert_match(/not a percentage/, error.message)
  end

  # gotchas

  def test_a_hash_default_is_one_shared_object_rather_than_a_fresh_one
    default = []
    shared = Hash.new(default)
    fresh = Hash.new { |hash, key| hash[key] = [] }

    shared["a"] << 1
    fresh["a"] << 1

    assert_empty shared
    assert_equal [1], shared["b"]
    assert_same default, shared["b"]
    assert_equal({ "a" => [1] }, fresh)
  end
end
