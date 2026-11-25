-- `import` takes a module name rather than a path. The first is the code under
-- test and the second is test.lean at the project root, which is the whole of
-- the test framework here -- Lean ships none, and `check` is two lines.
import {{PROJECT_SNAKE}}
import test

-- Nothing names this file. lakefile.toml globs test/ for the test library, so a
-- test file is found by being in that directory and deleting one is safe. Run
-- the suite with `make test`.
--
-- `#eval` is the thing worth stopping at. It runs the expression after it *while
-- the file is being compiled*, not afterwards -- so these assertions happen at
-- build time, and a failing test is a build failure with the test name as the
-- error message. There is no test binary and no runner.
--
-- `do` opens an imperative block, because `check` returns IO Unit. Lean is a
-- pure language with a notation for sequencing effects, exactly as Haskell is.
#eval do
  -- Arrange, act, assert, separated by blank lines. `let` inside a `do` block
  -- binds for the rest of it, and `:=` is the binding form -- a single `=` is
  -- the equality *proposition*, which is a different thing entirely and the
  -- distinction that matters most in this language.
  let name := "world"

  let greeting := {{PROJECT_SNAKE}}.greet name

  -- `<|` applies what is on the left to everything on the right, which saves a
  -- pair of brackets round the comparison. The name is a plain string and can
  -- be a real sentence; it is what the build prints when the claim is false.
  --
  -- `==` is the boolean comparison that runs. `=` would state a proposition
  -- about the two values -- something you prove rather than evaluate -- and
  -- that is the kata this course ends on.
  check "a greeting addresses the name it is given" <| greeting == "Hello, world!"
