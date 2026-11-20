package {{PROJECT_SNAKE}};

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw(greet);

sub greet {
    my ($name) = @_;
    return "Hello, $name!";
}

1;
