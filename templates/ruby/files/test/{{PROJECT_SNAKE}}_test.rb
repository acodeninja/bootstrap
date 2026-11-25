# frozen_string_literal: true

# minitest/autorun is the whole of the setup: requiring it installs an at_exit
# hook that runs every test it can see when the process ends. There is no runner
# to call and no suite to register with.
require "minitest/autorun"

# By name rather than by relative path, because the Rakefile puts both src and
# test on the load path.
require "{{PROJECT_SNAKE}}"

# Nothing names this file. minitest has no discovering command of its own, so the
# Rakefile globs test/**/*_test.rb and `make test` runs rake -- which is why
# deleting a test file is safe where naming one in the Rakefile would not be.
class GreeterTest < Minitest::Test
  # A method whose name begins with test_ is a test, and that is the entire
  # registration: no annotation, no block, no list. The name is what a failure
  # prints, so it is written as a sentence with underscores for the spaces.
  def test_a_greeting_addresses_the_name_it_is_given
    # Arrange, act, assert, separated by blank lines. Every test in this project
    # has those three parts in that order.
    name = "world"

    greeting = Greeter.greet(name)

    # Expected first, actual second, which is the opposite way round from
    # node:assert and reads backwards from the English. Swapping them still
    # passes and only makes the failure message name the wrong side.
    assert_equal "Hello, world!", greeting
  end
end
