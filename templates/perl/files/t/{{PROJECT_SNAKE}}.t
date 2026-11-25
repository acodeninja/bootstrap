use strict;
use warnings;

# Test::More is in core, so there is nothing to install.
use Test::More;

# `use lib` adds a directory to the module search path at compile time, which is
# what makes the next line work without a relative path or an installed module.
use lib 'src';

# The import list in qw() is what pulls `greet` into this file. Without it the
# module would load and the name would have to be written in full.
use {{PROJECT_SNAKE}} qw(greet);

# Nothing names this file. `make test` runs prove over t/, which takes every
# *.t in it -- so a test file is found by that extension and deleting one is
# safe. Run the suite with `make test`.
#
# There is no enclosing block and no test function: a .t file is a program that
# prints TAP, and Test::More is a set of functions that print it for you. So
# the assertions below are top-level statements, and the file is the suite.
#
# `is` takes the actual value, then the expected one, then the name. The name
# is what a failure prints, so write it to read on its own.
#
# It compares with `eq`, which is string comparison. `cmp_ok` is the one that
# takes an operator, and comparing numbers with `is` works by accident until it
# does not -- 1.0 and 1 are not `eq`.
is(
    greet('world'),
    'Hello, world!',
    'a greeting addresses the name it is given'
);

# Declares the suite finished and reports the count. The alternative is to say
# `plan tests => 1` up front; done_testing at the end means the number is never
# wrong, which is the better habit.
done_testing();
