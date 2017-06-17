#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Sub::Import::Force' ) || print "Bail out!\n";
}

diag( "Testing Sub::Import::Force $Sub::Import::Force::VERSION, Perl $], $^X" );
