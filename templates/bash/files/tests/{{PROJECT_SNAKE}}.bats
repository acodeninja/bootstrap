setup() {
  # shellcheck source-path=SCRIPTDIR source=../src/{{PROJECT_SNAKE}}.sh
  . "$BATS_TEST_DIRNAME/../src/{{PROJECT_SNAKE}}.sh"
}

@test "a greeting addresses the name it is given" {
  run greet world

  [ "$status" -eq 0 ]
  [ "$output" = 'Hello, world!' ]
}
