/-!
A namespace, which is Lean separating the module from the name: the file is the
module -- `import <project>` finds it -- and the namespace is what qualifies the
definitions inside, so the test calls `<project>.greet`.

Lean has four comment forms. `--` runs to the end of the line, `/- -/` is a
block comment and nests, `/-! -/` is module documentation like this one, and
`/-- -/` is a doc-string that must sit immediately before a declaration. The
last two are part of the syntax tree rather than being discarded, so they are
only legal where a declaration can follow.

Note also that `lakefile.toml` makes every warning an error here, so a commented
-out binding leaves an unused variable that fails `make lint`.
-/

namespace {{PROJECT_SNAKE}}

/-- Returns a greeting addressed to `name`. -/
-- `def` defines a term, and everything is a term: a function, a value, a proof.
-- The parameter is named and typed in parentheses, the return type follows the
-- colon, and `:=` separates the signature from the body.
--
-- The types are not optional here the way they are in Haskell or F#. Lean can
-- infer a great deal, and `autoImplicit` is switched off in this project so
-- that a name it does not recognise is an error rather than a silently
-- introduced implicit argument.
def greet (name : String) : String :=
  -- s! is string interpolation, and the exclamation mark is what makes the
  -- braces mean anything. Lean has a family of these prefixes -- m! builds a
  -- message for the compiler to print -- and the plain string would be literal.
  s!"Hello, {name}!"

end {{PROJECT_SNAKE}}
