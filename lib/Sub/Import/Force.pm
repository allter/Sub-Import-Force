package Sub::Import::Force;

use 5.006;
use strict;
use warnings;

=head1 NAME

Sub::Import::Force - Import other module's functions to your package forcefully

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

	use Sub::Import::Force 'MyModule' => qw(my_sub1 my_sub2);
	my_sub1;

	use Sub::Import::Force qw();
	my $import = Sub::Import::Force->get( 'MyModule' => qw(my_sub1 my_sub2) );
	$import->{my_sub2}->();

	use Sub::Import::Force qw();
	my $my_sub = Sub::Import::Force->get_one( 'MyModule' => qw(my_sub) );
	$my_sub->();

=cut

use Carp qw(croak);
#$Carp::Internal{ (__PACKAGE__) }++;

sub import
{
	my $self = shift;
	my $target = shift;

	if ( $target )
	{
		_require_target( $target );
		my $caller_package = (caller)[0];

		my $imports = $self->get( $target, @_ );
		foreach ( keys %$imports )
		{
			no strict 'refs';
			*{ "${caller_package}::$_" } = $imports->{ $_ };
		}
	}
}

sub get
{
	my $self = shift;
	my $target = shift;
	my @subroutines = @_;
	croak( "You need to have an import list for $target" ) unless @subroutines;

	_require_target( $target );

	my %imports;
	foreach ( @subroutines )
	{
		$imports{ $_ } = $self->_get_one( $target, $_ );

	}
	return \%imports;
}

sub get_one
{
	my $self = shift;
	my $target = shift;
	my $sub_name = shift or croak( "Need to specify subroutine name to import" );

	_require_target( $target );
	return $self->_get_one( $target, $sub_name );
}

sub _get_one
{
	my $self = shift;
	my $target = shift;
	my $sub_name = shift;

	{
		no strict 'refs';
		croak( "Subroutine $sub_name is not defined in package $target" )
			unless defined *{"${target}::$sub_name"}{CODE};
			#unless defined &{"$target::$sub_name"}; # doesn't work in older perls
	}
	my $sub = \&{"${target}::$sub_name"};
	die( "You should not see this error" ) unless ref $sub eq 'CODE';
	return $sub;
}

sub _module_to_filename # borrowed from base.pm :)
{
	(my $fn = $_[0]) =~ s!::!/!g;
	$fn .= '.pm';
	utf8::encode($fn);
	return $fn;
}

sub _require_target
{
	my $target = shift;
	my $fn = _module_to_filename( $target );
	eval { require $fn; };
	croak( $@ ) if $@; # TODO return only the line number at caller package
}

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Andrey Smirnov, C<< <allter at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-sub-import-force at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sub-Import-Force>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Sub::Import::Force


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sub-Import-Force>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Sub-Import-Force>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Sub-Import-Force>

=item * Search CPAN

L<http://search.cpan.org/dist/Sub-Import-Force/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Andrey Smirnov.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of Sub::Import::Force
