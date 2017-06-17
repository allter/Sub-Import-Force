package test::sub_import_force_test;
use warnings;
use strict;

use base 'Exporter';
our @EXPORT = qw(exported_sub);

sub exported_sub
{
	return 42;
}

sub not_exported_sub
{
	return 19;
}

1;

