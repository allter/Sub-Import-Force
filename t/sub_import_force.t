#!/usr/bin/perl
use Test::More tests => 3;

use lib 't/test_misc';

#require './Force.pm';
#use lib '../..';

#use Sub::Import::Force 'sub_import_force_test' => qw(exported_sub);
#warn exported_sub();

# This breaks the next import. It's the feature of perl.
#BEGIN { *{test::sub_import_force_test} = sub () { 0 }; }

#use Sub::Import::Force test::sub_import_force_test => qw(exported_sub);
#warn exported_sub();

use Sub::Import::Force 'sub_import_force_test' => qw(not_exported_sub);
ok not_exported_sub() == 19, 'not_exported_sub';

#use Sub::Import::Force 'sub_import_force_test' => qw(not_existing_sub);
#warn not_existing_sub();

#use Sub::Import::Force 'sub_import_force_test' => qw();
#warn not_imported_sub();

#use Sub::Import::Force 'nonexisting_module' => qw();
#warn not_imported_sub();

my $import = Sub::Import::Force->get( sub_import_force_test => qw(not_exported_sub) );
ok $import->{not_exported_sub}() == 19, '->get->not_exported_sub';

my $exported_sub = Sub::Import::Force->get_one( sub_import_force_test => qw(exported_sub) );
ok $exported_sub->() == 42, '->get_one->exported_sub';

=pod

use Sub::Import::Force qw();
my $import = Sub::Import::Force->get( 'MyModule' => qw(my_sub1 my_sub2) );
$import->{my_sub2}->();

use Sub::Import::Force qw();
my $my_sub = Sub::Import::Force->get_one( 'MyModule' => qw(my_sub) );
$my_sub->();

=cut



