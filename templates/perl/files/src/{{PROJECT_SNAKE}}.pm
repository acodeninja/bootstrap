# A package declaration. The name should match the file path below the library
# directory, which is how `use` finds it -- this one carries the project name.
# A .pm file is a module and a .pl file is a script, and the difference is only
# convention plus the true value at the foot of this file.
package {{PROJECT_SNAKE}};

# Two lines that belong at the top of every Perl file you write. `strict` makes
# an undeclared variable an error rather than a global, and `warnings` turns on
# the diagnostics that catch the rest. Neither is on by default, for reasons of
# history.
use strict;
use warnings;

# Exporting is a library rather than a language feature: Exporter supplies an
# `import` routine, and @EXPORT_OK lists what a caller may ask for by name.
# @EXPORT -- without the OK -- would push names into the caller whether they
# asked or not, which is the one to avoid.
#
# `our` declares a package variable, as against `my` which is lexical. qw() is
# a quoted list of words, so that is a one-element list of names.
use Exporter 'import';
our @EXPORT_OK = qw(greet);

# `sub` declares a subroutine, and the parentheses hold nothing: arguments
# arrive in the array @_ rather than being named in the signature.
sub greet {

    # Unpacking @_ into named variables, which is the first line of almost
    # every Perl subroutine. The parentheses on the left make it a list
    # assignment -- without them, `my $name = @_` would put the *count* of
    # arguments in $name, because an array in scalar context is its length.
    # That is the single most useful thing to know about this language.
    my ($name) = @_;

    # Double quotes interpolate and single quotes do not. The sigil stays in
    # the string: $name is interpolated, and @name would be too.
    return "Hello, $name!";
}

# A module has to end with a true value, which is how `use` knows it loaded.
# 1 is the conventional one, and omitting it is a confusing error.
1;
