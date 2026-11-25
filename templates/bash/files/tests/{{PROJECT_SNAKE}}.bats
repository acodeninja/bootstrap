# bats runs setup() before every test in the file, so the sourcing happens once
# per test rather than once per file -- which is what keeps tests independent of
# each other.
setup() {
  # A shellcheck directive, and it has to sit immediately above the line it is
  # about. source-path tells shellcheck where to resolve the path from, because
  # `-x` resolves a followed path against the working directory rather than
  # against the file; source= names the file explicitly. Move either line and
  # `make lint` goes red.
  #
  # BATS_TEST_DIRNAME is bats telling you where this file is, so the path works
  # whatever directory the suite is run from.
  # shellcheck source-path=SCRIPTDIR source=../src/{{PROJECT_SNAKE}}.sh
  . "$BATS_TEST_DIRNAME/../src/{{PROJECT_SNAKE}}.sh"
}

# Nothing names this file. `make test` points bats at tests/, which takes every
# *.bats in it, so a test file is found by existing and deleting one is safe.
# Run the suite with `make test`.
#
# @test is bats rather than bash: the file is preprocessed into a shell script,
# which is how a test gets a name in quotes rather than an identifier. It is
# what a failure prints, so write it to read on its own.
@test "a greeting addresses the name it is given" {
  # `run` is the whole reason bats exists. It calls the command, catches its
  # exit status in $status and its output in $output, and does not let a
  # non-zero status end the test -- which is what makes a refusal something you
  # can assert about rather than something that kills the run.
  run greet world

  # Two assertions, because there are two channels. A bash function answers
  # with an exit status and with whatever it printed, and a test that checked
  # only the output would pass for a function that printed the right thing and
  # then failed.
  #
  # There is no assertion library here: `[` is an ordinary command whose exit
  # status bats reads, so a failed comparison fails the test. -eq compares
  # numbers and = compares strings, and using the wrong one is a quiet bug.
  [ "$status" -eq 0 ]
  [ "$output" = 'Hello, world!' ]
}
