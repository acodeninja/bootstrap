defmodule GreeterTest do
  use ExUnit.Case

  test "a greeting addresses the name it is given" do
    name = "world"

    greeting = Greeter.greet(name)

    assert greeting == "Hello, world!"
  end
end
