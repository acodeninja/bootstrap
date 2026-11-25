-- `require` takes a module name rather than a path: no directory, no extension.
-- The Makefile puts src/ on the search path, so this finds the file beside it.
-- What comes back is whatever that file returned, which is why the local name
-- here is ours to choose.
local greeter = require("{{PROJECT_SNAKE}}")

-- Nothing names this file. busted takes every *_spec.lua under spec/, which is
-- what the suffix is for, so a spec is found by being named and deleting one is
-- safe. Run them with `make test`.
--
-- `it` is a plain function call: the name is its first argument and the body is
-- an anonymous function passed as its second. That is why a test name can be a
-- real sentence -- nothing had to be done to the language to allow it. It is
-- what a failure prints.
--
-- There is no enclosing `describe` here. busted allows a bare `it`, and a
-- describe block would only put a second name in front of this one.
it("a greeting addresses the name it is given", function()
  -- Arrange, act, assert, separated by blank lines. `local` again, for the same
  -- reason as in the module: without it this would be a global.
  local name = "world"

  local greeting = greeter.greet(name)

  -- `assert` here is busted replacing the standard library one, which is why it
  -- has fields. Expected first, actual second -- swapping them still passes and
  -- only makes the failure message name the wrong side as the problem.
  assert.equal("Hello, world!", greeting)
end)
