# Fifteen passing assertions: the toolbox for solving a kata in Bash.

setup() {
  # shellcheck source-path=SCRIPTDIR source=../src/{{PROJECT_SNAKE}}.sh
  . "$BATS_TEST_DIRNAME/../src/{{PROJECT_SNAKE}}.sh"
}

# collections
# Two of them, the indexed array and the associative array, and the second has
# to be declared before it behaves. There is no set type, no nesting, and no
# way to pass either one to a function by value.

@test "an array appends with += and slices by offset and length" {
  values=(1 2 4)
  values+=(8)

  [ "${#values[@]}" -eq 4 ]
  [ "${values[2]}" -eq 4 ]
  [ "${values[*]:1:2}" = '2 4' ]
}

@test "a missing associative array key reads as empty rather than failing" {
  declare -A counts=([a]=1 [b]=2)
  counts[c]=3

  [ "${counts[c]}" -eq 3 ]
  [ -z "${counts[z]}" ]
  [ ! -v 'counts[z]' ]
}

@test "there is no set, so the keys of an associative array are one" {
  items=(red blue red green)
  declare -A seen=()
  for item in "${items[@]}"; do seen[$item]=1; done

  [ "${#seen[@]}" -eq 3 ]
  [ -v 'seen[blue]' ]
}

# strings

@test "IFS governs both the split and the join" {
  record=a,b,c

  IFS=, read -r -a parts <<<"$record"

  [ "${#parts[@]}" -eq 3 ]

  local IFS=-

  [ "${parts[*]}" = 'a-b-c' ]
}

@test "parameter expansion slices, measures and substitutes without a tool" {
  text=kitchen

  [ "${#text}" -eq 7 ]
  [ "${text:0:4}" = 'kitc' ]
  [ "${text//t/T}" = 'kiTchen' ]
}

@test "a repeated character comes from printf and padding from its format" {
  printf -v bar '%0.s-' {1..5}

  [ "$bar" = '-----' ]
  [ "$(printf '%5s|%-5s|' ab cd)" = '   ab|cd   |' ]
}

# types and branching
# There are no records, no enums and no declared types: every value is text,
# and what reads it decides what it is. An associative array is the record you
# would otherwise have written down.

@test "an associative array is the only record bash has" {
  declare -A record=([name]=ada [length]=3)

  [ "${record[name]}" = 'ada' ]
  [ "${#record[@]}" -eq 2 ]
}

@test "case is the branch that yields a value for a fixed set of states" {
  describe() {
    case $1 in
      locked) printf 'refusing\n' ;;
      unlocked) printf 'opening\n' ;;
      *) printf 'unknown\n' ;;
    esac
  }

  [ "$(describe locked)" = 'refusing' ]
  [ "$(describe wedged)" = 'unknown' ]
}

@test "a value stays text until something declares it a number" {
  plain=2+3
  declare -i computed=2+3

  [ "$plain" = '2+3' ]
  [ "$computed" -eq 5 ]
}

# iteration

@test "a counting loop needs double parentheses to do arithmetic" {
  total=0
  for ((i = 0; i < 4; i++)); do
    total=$((total + i))
  done

  [ "$total" -eq 6 ]
}

@test "lookahead walks the index rather than the element" {
  values=(3 1 4 1)
  rises=0
  for i in "${!values[@]}"; do
    ((i + 1 < ${#values[@]})) || continue
    ((values[i] < values[i + 1])) && rises=$((rises + 1))
  done

  [ "$rises" -eq 1 ]
}

# functions

@test "a function is passed to a function by name and called through it" {
  twice() { printf '%s%s' "$1" "$1"; }
  apply() { "$1" "$2"; }

  [ "$(apply twice ab)" = 'abab' ]
}

@test "a fold is a loop, because there is nothing to return but text" {
  sum() {
    local total=0 n
    for n in "$@"; do total=$((total + n)); done
    printf '%s\n' "$total"
  }

  [ "$(sum 1 2 3 4)" -eq 10 ]
}

# errors
# Failure is an exit status, not an object: a non-zero return is the whole
# idiom, and `run` is what lets a test see one without the suite aborting on it.

@test "a refusal is a non-zero exit status that run captures" {
  halve() {
    (($1 % 2 == 0)) || {
      printf 'not even: %s\n' "$1" >&2
      return 1
    }
    printf '%s\n' $(($1 / 2))
  }

  run halve 7

  [ "$status" -eq 1 ]
  [ "$output" = 'not even: 7' ]
}

# gotchas
# The hour this saves. Every stage of a pipeline is a subshell, so a loop on the
# right of a `|` counts into a variable its own caller never sees. Redirecting
# from a process substitution keeps the loop in this shell, which is the
# spelling that works. shellcheck says the same thing, so the warning it would
# raise about the first half is the lesson and is silenced here on purpose.
# shellcheck disable=SC2030,SC2031

@test "a loop in a pipeline counts into a variable its caller cannot see" {
  count=0
  printf 'a\nb\nc\n' | while read -r _; do count=$((count + 1)); done

  [ "$count" -eq 0 ]

  while read -r _; do count=$((count + 1)); done < <(printf 'a\nb\nc\n')

  [ "$count" -eq 3 ]
}
