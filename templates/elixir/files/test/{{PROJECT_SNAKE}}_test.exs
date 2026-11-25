# Nothing names this file. `mix test` takes every *_test.exs under test/, runs
# test/test_helper.exs first to start ExUnit, and collects what it finds -- so a
# test is found by its filename ending in _test.exs, and deleting one is safe.
# Run the suite with `make test`.
defmodule GreeterTest do
  # `use` is not an import: it calls a macro in ExUnit.Case that writes code into
  # this module -- the `test` macro below, the setup machinery, and the
  # registration with the runner. `import` and `alias` are the ones that merely
  # bring names into scope.
  use ExUnit.Case

  # `test` is a macro, so the name is an ordinary string and can be a real
  # sentence. It is what a failure prints, so write it to read on its own.
  test "a greeting addresses the name it is given" do
    # Arrange, act, assert, separated by blank lines. This looks like assignment
    # and is not: `=` is the match operator, and a bare variable on the left
    # matches anything and binds. The same operator with a value on the left --
    # `"world" = name` -- is an assertion that would raise if it did not match.
    name = "world"

    greeting = Greeter.greet(name)

    # `assert` is a macro over an ordinary expression, not a function taking two
    # arguments. It rewrites what it was given so a failure prints both sides
    # and the difference -- which is why there is no assert_equal here, and no
    # expected-first order to remember.
    assert greeting == "Hello, world!"
  end
end
