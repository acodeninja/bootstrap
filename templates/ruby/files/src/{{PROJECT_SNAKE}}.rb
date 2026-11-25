# frozen_string_literal: true

# That first line is a magic comment and it has to be the first line. It makes
# every string literal in this file frozen, which is what Ruby is heading towards
# by default and what rubocop asks for -- a comment that changes how the file
# behaves, which is a thing to know about before you reorder anything.

# A module with `def self.` is how Ruby spells a namespaced function. There is no
# instance to make and nothing to export: a constant is visible as soon as the
# file is loaded, so the test reaches this as Greeter.greet.
module Greeter
  # The last expression in a method is its return value. An explicit `return` is
  # legal here and nobody writes one.
  #
  # #{} interpolates, and only inside double quotes -- in single quotes those
  # four characters are themselves, which is the kind of mistake that reaches a
  # user rather than a test.
  def self.greet(name)
    "Hello, #{name}!"
  end
end
