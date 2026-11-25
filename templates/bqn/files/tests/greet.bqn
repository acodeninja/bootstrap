# •Import evaluates a file and hands back its namespace, and the ⟨ ⟩ on the left
# destructures that namespace into names -- so each import lists exactly what it
# is taking. A name not listed is not available.
#
# tester.bqn is this project's own TAP vocabulary, twenty-five lines of it: BQN
# has no test framework, so the three functions below are source you can read.
⟨Plan, Ok, TapDone⟩ ← •Import "./tester.bqn"
⟨Greet⟩ ← •Import "../src/{{PROJECT_SNAKE}}.bqn"

# TAP opens with the number of assertions about to be made, and the runner checks
# that count against the ok lines it saw. Add an assertion and this line has to
# change with it: nothing counts for you.
Plan 1

# An assertion, read right to left as BQN is. ≡ compares two values for exact
# equality -- it is the one to use on lists, where = compares element by element
# and hands back a list of results rather than a single answer.
#
# Ok takes the name on its left and the result on its right, which is possible
# because a BQN function may be called infix with arguments either side. The name
# is what a failure prints, so write it to read on its own.
#
# Nothing names this file: `make test` runs every tests/*.bqn and reads the TAP
# each one prints, so a test file is found by existing. Run them with `make test`.
"a greeting addresses the name it is given" Ok "Hello, world!" ≡ Greet "world"

# Prints the summary the runner reads and exits non-zero if anything failed. @ is
# the null character, used here as the argument a function needs and nobody
# wants -- the BQN equivalent of passing unit.
TapDone @
