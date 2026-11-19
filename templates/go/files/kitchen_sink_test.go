package kitchensink

import (
	"errors"
	"fmt"
	"reflect"
	"strconv"
	"strings"
	"testing"
)

// collections

func TestASliceKeepsWhatYouAppendToItInOrder(t *testing.T) {
	items := []string{"a", "b"}

	items = append(items, "c")

	if len(items) != 3 {
		t.Errorf("len(items) = %d, want 3", len(items))
	}
	if !reflect.DeepEqual(items, []string{"a", "b", "c"}) {
		t.Errorf("items = %v, want [a b c]", items)
	}
	if !reflect.DeepEqual(items[1:3], []string{"b", "c"}) {
		t.Errorf("items[1:3] = %v, want [b c]", items[1:3])
	}
}

func TestALookupForAKeyThatIsNotThereComesBackAsTheZeroValue(t *testing.T) {
	counts := map[string]int{"a": 2, "b": 1}

	value, ok := counts["a"]

	if value != 2 || !ok {
		t.Errorf("counts[a] = %d, %v, want 2, true", value, ok)
	}
	if counts["z"] != 0 {
		t.Errorf("counts[z] = %d, want 0", counts["z"])
	}
}

func TestASetIsAMapWhoseValuesCarryNothing(t *testing.T) {
	letters := map[byte]struct{}{}

	for _, letter := range []byte("aba") {
		letters[letter] = struct{}{}
	}

	if len(letters) != 2 {
		t.Errorf("len(letters) = %d, want 2", len(letters))
	}
	if _, ok := letters['a']; !ok {
		t.Error("letters['a'] missing, want present")
	}
	if _, ok := letters['z']; ok {
		t.Error("letters['z'] present, want missing")
	}
}

// strings

func TestAStringSplitsIntoPartsAndJoinsBackUp(t *testing.T) {
	words := strings.Split("one two three", " ")

	if !reflect.DeepEqual(words, []string{"one", "two", "three"}) {
		t.Errorf("words = %v, want [one two three]", words)
	}
	if joined := strings.Join(words, "-"); joined != "one-two-three" {
		t.Errorf("joined = %q, want %q", joined, "one-two-three")
	}
}

func TestASliceOfAStringCountsBytesNotCharacters(t *testing.T) {
	text := "abcdef"

	if text[0] != 'a' {
		t.Errorf("text[0] = %q, want 'a'", text[0])
	}
	if text[0:3] != "abc" {
		t.Errorf("text[0:3] = %q, want %q", text[0:3], "abc")
	}
	if text[len(text)-2:] != "ef" {
		t.Errorf("text[len-2:] = %q, want %q", text[len(text)-2:], "ef")
	}
}

func TestTextIsBuiltByFormattingRepeatingAndTrimming(t *testing.T) {
	name := "world"
	count := 2

	if line := fmt.Sprintf("%s x%d", name, count); line != "world x2" {
		t.Errorf("line = %q, want %q", line, "world x2")
	}
	if repeated := strings.Repeat("ab", 3); repeated != "ababab" {
		t.Errorf("repeated = %q, want %q", repeated, "ababab")
	}
	if trimmed := strings.TrimSpace("  padded  "); trimmed != "padded" {
		t.Errorf("trimmed = %q, want %q", trimmed, "padded")
	}
}

// types and branching

func TestAStructCopiesItsFieldsWhenYouAssignIt(t *testing.T) {
	type point struct{ x, y int }
	record := point{x: 1, y: 2}

	moved := record
	moved.x = 5

	if moved.x != 5 || record.x != 1 {
		t.Errorf("moved.x = %d, record.x = %d, want 5, 1", moved.x, record.x)
	}
}

func TestABranchCanProduceAValueInsteadOfSettingOne(t *testing.T) {
	describe := func(n int) string {
		if n < 0 {
			return "negative"
		} else if n == 0 {
			return "zero"
		}
		return "positive"
	}

	cases := map[int]string{-1: "negative", 0: "zero", 1: "positive"}
	for n, want := range cases {
		if got := describe(n); got != want {
			t.Errorf("describe(%d) = %q, want %q", n, got, want)
		}
	}
}

type shape interface{ sides() int }
type triangle struct{}
type square struct{}
type pentagon struct{}

func (triangle) sides() int { return 3 }
func (square) sides() int   { return 4 }
func (pentagon) sides() int { return 5 }

func describeSides(s shape) string {
	switch s.(type) {
	case triangle:
		return "three sides"
	case square:
		return "four sides"
	default:
		return "unhandled"
	}
}

func TestATypeSwitchDoesNotHaveToCoverEveryCase(t *testing.T) {
	// pentagon has no case: the switch still compiles and falls to default.
	// Nothing checks that every implementation of shape got a branch.
	if got := describeSides(triangle{}); got != "three sides" {
		t.Errorf("describeSides(triangle{}) = %q, want %q", got, "three sides")
	}
	if got := describeSides(square{}); got != "four sides" {
		t.Errorf("describeSides(square{}) = %q, want %q", got, "four sides")
	}
	if got := describeSides(pentagon{}); got != "unhandled" {
		t.Errorf("describeSides(pentagon{}) = %q, want %q", got, "unhandled")
	}
}

// iteration

func TestALoopCanReadBothTheIndexAndTheItem(t *testing.T) {
	seen := []string{}

	for index, item := range []string{"a", "b"} {
		seen = append(seen, fmt.Sprintf("%d:%s", index, item))
	}

	if !reflect.DeepEqual(seen, []string{"0:a", "1:b"}) {
		t.Errorf("seen = %v, want [0:a 1:b]", seen)
	}
}

func TestASequenceCanBeWalkedTwoItemsAtATime(t *testing.T) {
	values := []int{1, 2, 3, 4}
	pairs := []int{}

	for i := 0; i < len(values)-1; i++ {
		pairs = append(pairs, values[i]+values[i+1])
	}

	if !reflect.DeepEqual(pairs, []int{3, 5, 7}) {
		t.Errorf("pairs = %v, want [3 5 7]", pairs)
	}
}

// functions

func TestAFunctionCanBeHandedToAnotherFunction(t *testing.T) {
	double := func(n int) int { return n * 2 }
	apply := func(values []int, f func(int) int) []int {
		out := make([]int, len(values))
		for i, value := range values {
			out[i] = f(value)
		}
		return out
	}

	doubled := apply([]int{1, 2, 3}, double)

	if !reflect.DeepEqual(doubled, []int{2, 4, 6}) {
		t.Errorf("doubled = %v, want [2 4 6]", doubled)
	}
}

func TestASliceIsFoldedDownToASingleValueByALoop(t *testing.T) {
	// The stdlib slices package has no generic Reduce: a fold is a loop.
	values := []int{1, 2, 3, 4}

	total := 0
	for _, value := range values {
		total += value
	}

	if total != 10 {
		t.Errorf("total = %d, want 10", total)
	}
}

// errors

var errNotAPercentage = errors.New("not a percentage")

func parsePercentage(input string) (int, error) {
	value, err := strconv.Atoi(input)
	if err != nil || value < 0 || value > 100 {
		return 0, fmt.Errorf("parse %q: %w", input, errNotAPercentage)
	}
	return value, nil
}

func TestAnInvalidInputIsReportedThroughASentinelErrorNotAPanic(t *testing.T) {
	value, err := parsePercentage("40")
	if err != nil || value != 40 {
		t.Errorf("parsePercentage(40) = %d, %v, want 40, nil", value, err)
	}

	if _, err := parsePercentage("half"); !errors.Is(err, errNotAPercentage) {
		t.Errorf("parsePercentage(half) err = %v, want errNotAPercentage", err)
	}

	if _, err := parsePercentage("140"); !errors.Is(err, errNotAPercentage) {
		t.Errorf("parsePercentage(140) err = %v, want errNotAPercentage", err)
	}
}

// gotchas

type boom struct{}

func (*boom) Error() string { return "boom" }

func mightFail(fail bool) error {
	var err *boom
	if fail {
		err = &boom{}
	}
	return err
}

func TestANilPointerStoredInAnInterfaceIsNotANilInterface(t *testing.T) {
	// mightFail returns a *boom through an error-typed return value. Even
	// when that pointer is nil, the interface it is stored in carries a
	// type, so comparing the interface to nil is false.
	err := mightFail(false)

	if err == nil {
		t.Error("err == nil, want a non-nil interface wrapping a nil *boom")
	}
}
