# Fifteen passing assertions: the toolbox for solving a kata in Perl.

use strict;
use warnings;

use Test::More;
use List::Util qw(max reduce sum0);
use constant {
    LOCKED   => 'locked',
    UNLOCKED => 'unlocked',
};

sub parse_positive {
    my ($text) = @_;
    die "not a number: $text\n" if $text !~ /\A[0-9]+\z/;
    return 0 + $text;
}

sub apply_to {
    my ( $transform, @values ) = @_;
    return map { $transform->($_) } @values;
}

# collections

subtest 'an array keeps what you put in it, in order' => sub {
    my @items = ( 'a', 'b' );

    push @items, 'c';

    is( scalar @items, 3 );
    is( $items[1],     'b' );
    is_deeply( [ @items[ 1 .. 2 ] ], [ 'b', 'c' ] );
};

subtest 'a lookup for a key that is not there comes back undef' => sub {
    my %counts = ( a => 2, b => 1 );

    is( $counts{a}, 2 );
    is( $counts{z}, undef );
    ok( !exists $counts{z} );
};

# A hash is the set: the keys are the members and the values are along for the
# ride, which is why uniqueness costs nothing to ask for.
subtest 'a hash is how you ask whether you have seen something' => sub {
    my %seen;

    $seen{$_} = 1 for qw(a b a);

    is( scalar keys %seen, 2 );
    ok( exists $seen{a} );
    ok( !exists $seen{z} );
};

# strings

subtest 'a string splits into a list and joins back up' => sub {
    my @words = split / /, 'one two three';

    is_deeply( \@words, [ 'one', 'two', 'three' ] );
    is( join( '-', @words ), 'one-two-three' );
    is( scalar @words,       3 );
};

subtest 'a substring is taken by offset and length, counting from zero' => sub {
    my $text = 'abcdef';

    is( substr( $text, 0, 1 ), 'a' );
    is( substr( $text, 0, 3 ), 'abc' );
    is( substr( $text, -2 ), 'ef' );
};

subtest 'text is built up by interpolation, repetition and sprintf' => sub {
    my $name = 'world';

    is( "hello, $name",                'hello, world' );
    is( 'ab' x 3,                      'ababab' );
    is( sprintf( '%s x%d', $name, 2 ), 'world x2' );
};

# types and branching

# A reference is the record, and the distinction worth knowing early is that
# copying the reference shares the thing while copying the hash does not.
subtest 'assigning a reference shares it, assigning the hash copies it' => sub {
    my $point = { x => 1, y => 2 };

    my $alias = $point;
    $alias->{x} = 5;

    is( $point->{x}, 5 );

    my %copy = %{$point};
    $copy{x} = 9;

    is( $point->{x}, 5 );
    is( $copy{y},    2 );
};

subtest 'a fixed set of states is a set of constants' => sub {
    is( LOCKED, 'locked' );
    isnt( LOCKED, UNLOCKED );
};

# Nearly everything in Perl is an expression, so a branch yields a value
# directly -- the opposite of a language where every arm has to assign.
subtest 'a branch yields a value rather than assigning one' => sub {
    my $state = UNLOCKED;

    my $outcome = $state eq LOCKED ? 'shut' : 'open';

    is( $outcome, 'open' );

    my $described = do {
        if    ( $state eq LOCKED )   { 'shut' }
        elsif ( $state eq UNLOCKED ) { 'open' }
        else                         { 'unknown' }
    };

    is( $described, 'open' );
};

# iteration

subtest 'a loop can read both the position and the item' => sub {
    my @values = ( 1, 2, 3, 4 );

    my $weighted = 0;
    for my $at ( 0 .. $#values ) {
        $weighted += ( $at + 1 ) * $values[$at];
    }

    is( $weighted, 30 );
    is( $#values,  3 );
};

subtest 'a sequence can be walked two items at a time' => sub {
    my @values = ( 1, 2, 4, 8 );

    my @gaps;
    for my $at ( 0 .. $#values - 1 ) {
        push @gaps, $values[ $at + 1 ] - $values[$at];
    }

    is_deeply( \@gaps, [ 1, 2, 4 ] );
};

# functions

subtest 'a function is handed to another function as a code reference' => sub {
    my $doubled = sub { return $_[0] * 2 };

    my @mapped = apply_to( $doubled, 1, 2, 3 );

    is_deeply( \@mapped, [ 2, 4, 6 ] );
    is( $doubled->(4), 8 );
};

subtest 'a list is folded to one value' => sub {
    my @values = ( 1, 2, 3, 4 );

    my $product = reduce { $a * $b } @values;

    is( sum0(@values), 10 );
    is( max(@values),  4 );
    is( $product,      24 );
};

# errors

# Failure is a die, which is an exception in all but name, and eval is the
# block that catches it. $@ holds the message, and is empty when nothing threw.
subtest 'an invalid input is refused by dying' => sub {
    is( parse_positive('42'), 42 );

    my $survived = eval { parse_positive('nope'); 1 };

    ok( !$survived );
    like( $@, qr/not a number/ );
};

# gotchas

# The hour this saves: the same array answers differently depending on what the
# left-hand side wants. A scalar wants a count; a list wants the elements.
subtest 'an array in scalar context is its own length' => sub {
    my @values = ( 10, 20, 30 );

    my $count = @values;
    my ($first) = @values;

    is( $count,         3 );
    is( $first,         10 );
    is( "@values[0,1]", '10 20' );
};

done_testing();
