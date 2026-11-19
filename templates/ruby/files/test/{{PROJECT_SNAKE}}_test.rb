# frozen_string_literal: true

require "minitest/autorun"

require "{{PROJECT_SNAKE}}"

class GreeterTest < Minitest::Test
  def test_a_greeting_addresses_the_name_it_is_given
    name = "world"

    greeting = Greeter.greet(name)

    assert_equal "Hello, world!", greeting
  end
end
