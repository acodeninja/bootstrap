#include "unity.h"

#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* collections */

void test_an_array_is_as_long_as_it_was_declared_and_you_count_the_rest(void) {
  int values[8] = {1, 2, 3};
  size_t count = 3;

  values[count] = 4;
  count++;

  TEST_ASSERT_EQUAL_size_t(8, sizeof(values) / sizeof(values[0]));
  TEST_ASSERT_EQUAL_size_t(4, count);
  TEST_ASSERT_EQUAL_INT(4, values[3]);
}

static int index_of(const int *values, size_t count, int wanted) {
  for (size_t i = 0; i < count; i++) {
    if (values[i] == wanted) {
      return (int)i;
    }
  }
  return -1;
}

void test_membership_is_a_loop_because_there_is_no_map_and_no_set(void) {
  int values[] = {10, 20, 30};

  TEST_ASSERT_EQUAL_INT(1, index_of(values, 3, 20));
  TEST_ASSERT_EQUAL_INT(-1, index_of(values, 3, 99));
  TEST_ASSERT_TRUE(index_of(values, 3, 30) >= 0);
}

void test_a_slice_is_a_copy_you_make_yourself(void) {
  int values[] = {1, 2, 3, 4, 5};
  int slice[2];

  memcpy(slice, values + 1, sizeof(slice));

  TEST_ASSERT_EQUAL_INT(2, slice[0]);
  TEST_ASSERT_EQUAL_INT(3, slice[1]);
  TEST_ASSERT_EQUAL_INT(2, values[1]);
}

/* strings */

void test_a_string_is_a_character_array_that_ends_in_a_zero_byte(void) {
  char text[] = "abc";

  TEST_ASSERT_EQUAL_size_t(3, strlen(text));
  TEST_ASSERT_EQUAL_size_t(4, sizeof(text));
  TEST_ASSERT_EQUAL_CHAR('a', text[0]);
  TEST_ASSERT_EQUAL_CHAR('\0', text[3]);
}

void test_splitting_a_string_cuts_the_original_up_in_place(void) {
  char text[] = "one two three";
  char joined[32] = "";

  for (char *part = strtok(text, " "); part != NULL; part = strtok(NULL, " ")) {
    if (joined[0] != '\0') {
      strcat(joined, "-");
    }
    strcat(joined, part);
  }

  TEST_ASSERT_EQUAL_STRING("one-two-three", joined);
  TEST_ASSERT_EQUAL_STRING("one", text);
}

void test_formatting_reports_the_length_it_needed_not_the_length_it_wrote(void) {
  char line[8];

  int needed = snprintf(line, sizeof(line), "%s x%d", "ab", 2);

  TEST_ASSERT_EQUAL_INT(5, needed);
  TEST_ASSERT_EQUAL_STRING("ab x2", line);
  TEST_ASSERT_TRUE(snprintf(NULL, 0, "%s x%d", "abcdefghij", 2) > (int)sizeof(line));
}

/* types and branching */

struct point {
  int x;
  int y;
};

void test_a_struct_is_copied_when_you_assign_it(void) {
  struct point record = {.x = 1, .y = 2};

  struct point moved = record;
  moved.x = 5;

  TEST_ASSERT_EQUAL_INT(5, moved.x);
  TEST_ASSERT_EQUAL_INT(2, moved.y);
  TEST_ASSERT_EQUAL_INT(1, record.x);
}

enum level { LOW, MIDDLE, HIGH };

static const char *name_of(enum level value) {
  switch (value) {
  case LOW:
    return "low";
  case MIDDLE:
    return "middle";
  case HIGH:
    return "high";
  }
  return "unknown";
}

void test_an_enum_is_a_set_of_named_integers_counting_up_from_zero(void) {
  enum level value = MIDDLE;

  TEST_ASSERT_EQUAL_INT(0, LOW);
  TEST_ASSERT_EQUAL_INT(1, value);
  TEST_ASSERT_EQUAL_STRING("middle", name_of(value));
  TEST_ASSERT_EQUAL_STRING("high", value < HIGH ? name_of(HIGH) : name_of(LOW));
}

enum kind { KIND_NUMBER, KIND_TEXT };

struct tagged {
  enum kind kind;
  union {
    int number;
    const char *text;
  } as;
};

static const char *describe(struct tagged value, char *out, size_t size) {
  switch (value.kind) {
  case KIND_NUMBER:
    snprintf(out, size, "number %d", value.as.number);
    break;
  case KIND_TEXT:
    snprintf(out, size, "text %s", value.as.text);
    break;
  }
  return out;
}

void test_a_sum_type_is_a_struct_holding_a_tag_you_check_yourself(void) {
  struct tagged number = {.kind = KIND_NUMBER, .as = {.number = 7}};
  struct tagged text = {.kind = KIND_TEXT, .as = {.text = "seven"}};
  char buffer[32];

  TEST_ASSERT_EQUAL_STRING("number 7", describe(number, buffer, sizeof(buffer)));
  TEST_ASSERT_EQUAL_STRING("text seven", describe(text, buffer, sizeof(buffer)));
  TEST_ASSERT_EQUAL_size_t(sizeof(number), sizeof(text));
}

/* iteration */

void test_a_loop_counts_the_index_itself_because_there_is_nothing_to_iterate(void) {
  const char *items[] = {"a", "b"};
  char seen[16] = "";

  for (size_t i = 0; i < sizeof(items) / sizeof(items[0]); i++) {
    char entry[8];
    snprintf(entry, sizeof(entry), "%zu:%s", i, items[i]);
    strcat(seen, entry);
  }

  TEST_ASSERT_EQUAL_STRING("0:a1:b", seen);
}

void test_lookahead_is_reading_the_next_index_so_the_loop_stops_one_early(void) {
  int values[] = {1, 2, 3, 4};
  int sums[3];
  size_t count = 0;

  for (size_t i = 0; i + 1 < 4; i++) {
    sums[count++] = values[i] + values[i + 1];
  }

  TEST_ASSERT_EQUAL_size_t(3, count);
  TEST_ASSERT_EQUAL_INT(3, sums[0]);
  TEST_ASSERT_EQUAL_INT(7, sums[2]);
}

/* functions */

static int doubled(int value) { return value * 2; }

static int negated(int value) { return -value; }

static void map_over(const int *values, size_t count, int (*apply)(int), int *out) {
  for (size_t i = 0; i < count; i++) {
    out[i] = apply(values[i]);
  }
}

void test_a_function_pointer_is_a_value_you_can_hand_to_another_function(void) {
  int values[] = {1, 2, 3};
  int doubles[3];
  int negatives[3];

  map_over(values, 3, doubled, doubles);
  map_over(values, 3, negated, negatives);

  TEST_ASSERT_EQUAL_INT(2, doubles[0]);
  TEST_ASSERT_EQUAL_INT(6, doubles[2]);
  TEST_ASSERT_EQUAL_INT(-1, negatives[0]);
}

static int added(int total, int value) { return total + value; }

static int fold(const int *values, size_t count, int initial, int (*combine)(int, int)) {
  int total = initial;
  for (size_t i = 0; i < count; i++) {
    total = combine(total, values[i]);
  }
  return total;
}

void test_folding_a_sequence_means_one_accumulator_and_one_loop(void) {
  int values[] = {1, 2, 3, 4};

  int total = fold(values, 4, 0, added);

  TEST_ASSERT_EQUAL_INT(10, total);
  TEST_ASSERT_EQUAL_INT(0, fold(values, 0, 0, added));
}

/* errors */

static int parse_percentage(const char *text, int *out) {
  char *end = NULL;
  long value = strtol(text, &end, 10);
  if (end == text || *end != '\0' || value < 0 || value > 100) {
    errno = EINVAL;
    return -1;
  }
  *out = (int)value;
  return 0;
}

void test_a_refusal_is_a_return_code_and_errno_outlives_the_call_that_set_it(void) {
  int parsed = 0;

  errno = 0;
  int refused = parse_percentage("half", &parsed);
  int accepted = parse_percentage("40", &parsed);

  TEST_ASSERT_EQUAL_INT(-1, refused);
  TEST_ASSERT_EQUAL_INT(0, accepted);
  TEST_ASSERT_EQUAL_INT(40, parsed);
  TEST_ASSERT_EQUAL_INT(EINVAL, errno);
}

/* gotchas */

struct pair {
  int values[2];
};

static void bump_array(int values[2]) { values[0]++; }

static int bump_struct(struct pair record) {
  record.values[0]++;
  return record.values[0];
}

void test_an_array_argument_is_not_copied_but_a_struct_holding_one_is(void) {
  int values[2] = {1, 2};
  struct pair record = {.values = {1, 2}};

  bump_array(values);
  int seen_inside = bump_struct(record);

  TEST_ASSERT_EQUAL_INT(2, values[0]);
  TEST_ASSERT_EQUAL_INT(2, seen_inside);
  TEST_ASSERT_EQUAL_INT(1, record.values[0]);
}
