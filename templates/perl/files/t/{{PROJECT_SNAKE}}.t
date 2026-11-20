use strict;
use warnings;

use Test::More;
use lib 'src';
use {{PROJECT_SNAKE}} qw(greet);

is(
    greet('world'),
    'Hello, world!',
    'a greeting addresses the name it is given'
);

done_testing();
