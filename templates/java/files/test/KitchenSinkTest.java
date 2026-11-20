import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotSame;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class KitchenSinkTest {
  // collections

  @Test
  @DisplayName("a list keeps what you put in it, in order")
  void listKeepsOrder() {
    List<String> items = new ArrayList<>(List.of("a", "b"));

    items.add("c");

    assertEquals(List.of("a", "b", "c"), items);
    assertEquals(3, items.size());
    assertEquals(List.of("b", "c"), items.subList(1, 3));
  }

  @Test
  @DisplayName("a lookup for a key that is not there comes back null")
  void mapLookupMissingKey() {
    Map<String, Integer> counts = Map.of("a", 2, "b", 1);

    assertEquals(2, counts.get("a"));
    assertNull(counts.get("z"));
    assertEquals(0, counts.getOrDefault("z", 0));
  }

  @Test
  @DisplayName("a set discards duplicates")
  void setDiscardsDuplicates() {
    Set<String> letters = new HashSet<>(List.of("a", "b", "a"));

    assertEquals(2, letters.size());
    assertTrue(letters.contains("a"));
    assertFalse(letters.contains("z"));
  }

  // strings

  @Test
  @DisplayName("a string splits into parts and joins back up")
  void stringSplitsAndJoins() {
    String[] words = "one two three".split(" ");

    assertArrayEquals(new String[] {"one", "two", "three"}, words);
    assertEquals("one-two-three", String.join("-", words));
  }

  @Test
  @DisplayName("a slice of a string counts from zero")
  void stringSliceFromZero() {
    String text = "abcdef";

    assertEquals('a', text.charAt(0));
    assertEquals("abc", text.substring(0, 3));
    assertEquals("ef", text.substring(text.length() - 2));
  }

  @Test
  @DisplayName("text can be built up with a formatted template")
  void textFormattedTemplate() {
    String name = "world";
    int count = 2;

    assertEquals("world x2", "%s x%d".formatted(name, count));
    assertEquals("ababab", "ab".repeat(3));
    assertEquals("padded", "  padded  ".trim());
  }

  // types and branching

  record Point(int x, int y) {}

  @Test
  @DisplayName("a record compares equal to another record with the same values")
  void recordEqualsByValue() {
    Point record = new Point(1, 2);

    Point same = new Point(1, 2);

    assertEquals(record, same);
    assertEquals(1, record.x());
  }

  enum State {
    LOCKED,
    OPEN
  }

  @Test
  @DisplayName("a switch expression over an enum must cover every case")
  void switchOverEnumIsExhaustive() {
    // Drop a case here and this stops compiling, because the result is
    // assigned. A switch statement with no assignment is not checked that way.
    State state = State.LOCKED;

    State next =
        switch (state) {
          case LOCKED -> State.OPEN;
          case OPEN -> State.LOCKED;
        };

    assertEquals(State.OPEN, next);
  }

  @Test
  @DisplayName("a pattern-matching switch branches on type and a guard at once")
  void patternMatchingSwitch() {
    Object value = -5;

    String label =
        switch (value) {
          case Integer n when n < 0 -> "negative";
          case Integer n when n == 0 -> "zero";
          case Integer n -> "positive";
          default -> "unknown";
        };

    assertEquals("negative", label);
  }

  // iteration

  @Test
  @DisplayName("a loop can read both the position and the item")
  void loopReadsIndexAndItem() {
    List<String> items = List.of("a", "b");
    List<String> seen = new ArrayList<>();

    for (int index = 0; index < items.size(); index++) {
      seen.add(index + ":" + items.get(index));
    }

    assertEquals(List.of("0:a", "1:b"), seen);
  }

  @Test
  @DisplayName("a sequence can be walked two items at a time")
  void sequenceWalkedWithLookahead() {
    List<Integer> values = List.of(1, 2, 3, 4);
    List<Integer> sums = new ArrayList<>();

    for (int i = 0; i < values.size() - 1; i++) {
      sums.add(values.get(i) + values.get(i + 1));
    }

    assertEquals(List.of(3, 5, 7), sums);
  }

  // functions

  static int doubleValue(int n) {
    return n * 2;
  }

  @Test
  @DisplayName("a function can be handed to another function")
  void functionHandedToFunction() {
    List<Integer> values = List.of(1, 2, 3);

    List<Integer> doubled = values.stream().map(KitchenSinkTest::doubleValue).toList();
    List<Integer> big = values.stream().filter(n -> n > 1).toList();

    assertEquals(List.of(2, 4, 6), doubled);
    assertEquals(List.of(2, 3), big);
  }

  @Test
  @DisplayName("a list can be folded down to a single value")
  void listFoldedToSingleValue() {
    List<Integer> values = List.of(1, 2, 3, 4);

    int total = values.stream().reduce(0, Integer::sum);

    assertEquals(10, total);
  }

  // errors

  static class PercentageException extends Exception {
    PercentageException(String message) {
      super(message);
    }
  }

  static int parsePercentage(String input) throws PercentageException {
    int value;
    try {
      value = Integer.parseInt(input);
    } catch (NumberFormatException e) {
      throw new PercentageException("not a percentage: " + input);
    }
    if (value < 0 || value > 100) {
      throw new PercentageException("not a percentage: " + value);
    }
    return value;
  }

  @Test
  @DisplayName("an invalid input is refused rather than guessed at")
  void invalidInputIsRefused() throws PercentageException {
    // The throws clause above is part of the method's contract: the compiler
    // will not let a caller ignore it the way an unchecked exception allows.
    assertEquals(40, parsePercentage("40"));
    PercentageException thrown =
        assertThrows(PercentageException.class, () -> parsePercentage("140"));
    assertEquals("not a percentage: 140", thrown.getMessage());
  }

  // gotchas

  @Test
  @DisplayName("boxed integers are only the same object inside the cached range")
  void boxedIntegerIdentityCache() {
    Integer smallA = 100;
    Integer smallB = 100;
    Integer bigA = 200;
    Integer bigB = 200;

    assertSame(smallA, smallB);
    assertNotSame(bigA, bigB);
    assertEquals(bigA, bigB);
  }
}
