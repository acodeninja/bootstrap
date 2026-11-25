# `unit module` makes the whole file one module, which is why there are no braces
# around anything below it. It has to be the first statement in the file, so a
# comment above it is the only thing that may come first.
#
# The name should match the file path below the library directory, which is how
# `use` finds it. Raku has three comment forms: a hash to end of line, #`( ... )
# for an embedded one, and =begin pod ... =end pod for documentation.
unit module {{PROJECT_SNAKE}};

# `sub` declares a subroutine, and this signature is doing three things at once
# that Perl could not. The parameter is named and typed -- Str $name -- so the
# caller is checked; the arrow gives the return type, which is also checked; and
# `is export` is a trait that marks the name for export, where Perl needed a
# module and an array.
#
# Typing is gradual: `$name` with no type would accept anything, and the check
# simply would not happen. Writing the types is the habit worth having.
sub greet(Str $name --> Str) is export {
    # No `return`. The last statement in a block is its value, which is new
    # since Perl -- and `return` still exists for leaving early.
    #
    # Double quotes interpolate and single quotes do not. Raku interpolates far
    # more than Perl does inside double quotes, including a whole expression in
    # braces, which is worth knowing before you put a literal brace in a string.
    "Hello, $name!"
}
