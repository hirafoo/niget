package DBIx::Class::InflateColumn::DateTime::Auto;

use strict;
use warnings;

our $VERSION = '0.03';

use base qw/DBIx::Class::InflateColumn::DateTime/;

use DateTime;

__PACKAGE__->mk_classdata( datetime_timezone => 'local' );
__PACKAGE__->mk_classdata(
    _auto_create_datetime_columns => [qw/created_on created_at/] );
__PACKAGE__->mk_classdata(
    _auto_update_datetime_columns => [qw/updated_on updated_at/] );

sub auto_create_datetime_columns {
    my $self = shift;
    for (@_) {
        $self->throw_exception("column $_ doesn't exist")
          unless $self->has_column($_);
    }
    $self->_auto_create_datetime_columns( \@_ ) if @_;
    $self->_auto_create_datetime_columns;
}

sub auto_update_datetime_columns {
    my $self = shift;
    for (@_) {
        $self->throw_exception("column $_ doesn't exist")
          unless $self->has_column($_);
    }
    $self->_auto_update_datetime_columns( \@_ ) if @_;
    $self->_auto_update_datetime_columns;
}

sub insert {
    my $self = shift;

    my $now = $self->get_current_datetime;
    for my $column (
        @{ $self->auto_create_datetime_columns },
        @{ $self->auto_update_datetime_columns }
      )
    {
        if ( $self->has_column($column) ) {
            $self->set_inflated_column( $column => $now )
              unless $self->get_column($column);
        }
    }
    $self->next::method(@_);
}

sub update {
    my $self = shift;

    my $now = $self->get_current_datetime;
    for my $column ( @{ $self->auto_update_datetime_columns } ) {
        if ( $self->has_column($column) ) {
            $self->set_inflated_column( $column => $now )
              unless $self->is_column_changed($column);
        }
    }
    $self->next::method(@_);
}

sub get_current_datetime {
    my $self = shift;
    return DateTime->now( time_zone => $self->datetime_timezone );
}

sub register_column {
    my ($self, $column, $info, @rest) = @_;

    my $type = $info->{data_type};
    if (defined $type and lc($type) =~ /^(?:date(?:time)?|timestamp)$/) {
        $info->{extra} ||= {};
        $info->{extra}->{timezone} ||= $self->datetime_timezone;
    }

    return $self->next::method($column, $info, @rest);
}

1;

__END__

=head1 NAME

DBIx::Class::InflateColumn::DateTime::Auto -  automaticaly insert/update datetime column

=head1 SYNOPSIS

 package Users;

 use base qw/DBIx::Class/

 __PACKAGE__->load_components(qw/PK::Auto InflateColumn::DateTime::Auto Core/);
 __PACKAGE__->table('users');
 __PACKAGE__->add_columns(
     qw/id name password/,
     created_on => {data_type => 'datetime'},
     updated_on => {data_type => 'datetime'}
 );
 __PACKAGE__->set_primary_key('id');

 1;

=head1 DESCRIPTION

This is extended class of DBIx::Class::InflateColumn::DateTime, which
automaticaly set current datetime to defined columns.

In default:
auto insert columns: created_on created_at, and auto update columns
auto update columns: updated_on updated_at

=head1 METHODS

=over 4

=item auto_create_datetime_columns

 __PACKAGE__->auto_create_datetime_columns(qw/saved_on/);

you can change auto insert columns.

=item auto_update_datetime_columns

 __PACKAGE__->auto_create_datetime_columns(qw/changed_on/);

you can change auto update columns.

=back

=head1 SEE ALSO

L<DBIx::Class::InflateColumn::DateTime>

=head1 AUTHOR

Hideo Kimura C<< <<hide@hide-k.net>> >>

=head1 ORIGINAL IDEA

Lyo Kato C<< <<lyo.kato@gmail.com>> >>

=head1 COPYRIGHT

Copyright (c) 2006 by Hideo Kimura

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=cut
