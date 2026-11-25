# A module is the unit, and its name is independent of the filename: this file is
# named after the project and the module is Greeter, which is what callers write.
# Nothing lists the file -- mix.exs points the compiler at src/ and it takes
# everything there.
#
# .ex is compiled; .exs is evaluated as a script. That is the whole difference,
# and it is why the test beside this one is .exs.
defmodule Greeter do
  # @moduledoc false says "deliberately undocumented" rather than leaving the
  # question open. Credo asks for one or the other; a real @moduledoc would be a
  # heredoc of documentation that ships in the compiled module and reaches `h
  # Greeter` in iex.
  @moduledoc false

  # `def` is public and `defp` is private, and that is the whole of visibility.
  # There are no type annotations here -- @spec adds them for the dialyzer, and
  # they are checked by that rather than by the compiler.
  #
  # `, do:` is the one-line form of a body; the longer form is `do` ... `end`.
  # Both are the same thing: `do` is a keyword list argument, not syntax.
  #
  # #{} interpolates inside a double-quoted string. Note what the result is: a
  # binary, which is Elixir's string, where a single-quoted literal would be a
  # charlist and a different type with a different printed form.
  def greet(name), do: "Hello, #{name}!"
end
