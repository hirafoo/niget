package DBIx::Class::TimeStamp::Auto;

use strict;
use warnings;
our $VERSION = '0.01';

use base 'DBIx::Class::InflateColumn::DateTime::Auto';
use DBIx::Class::ResultSet ();

sub import {
    my $class = shift;
    my %columns = ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    if (my $create = $columns{auto_create_datetime_columns}) {
        $create = [$create] if ref $create ne 'ARRAY';
        $class->_auto_create_datetime_columns($create);
    }

    if (my $update = $columns{auto_update_datetime_columns}) {
        $update = [$update] if ref $update ne 'ARRAY';
        $class->_auto_update_datetime_columns($update);
    }

    if (my $timezone = $columns{datetime_timezone}) {
        $class->datetime_timezone($timezone);
    }
}

package DBIx::Class::ResultSet;

use Class::Method::Modifiers;

__PACKAGE__->mk_classdata(timestamp_class => 'DBIx::Class::TimeStamp::Auto');

before update => sub {
    my ($self, $attrs) = @_;

    return if ref $attrs ne 'HASH';

    my $now;
    my $timestamp_class = $self->timestamp_class;

    for (@{$timestamp_class->auto_update_datetime_columns}) {
        $attrs->{$_} = $now ||= $timestamp_class->get_current_datetime
            if !defined $attrs->{$_} and $self->is_inflate_datetime_column($_);
    }
};

sub is_inflate_datetime_column {
    my ($self, $column) = @_;

    my $source = $self->result_source;
    my $info   = $source->column_info($column) if $source->has_column($column);

    return 1 if $info->{data_type} =~ /^(?:date(?:time)?|timestamp)$/i
            and $info->{_inflate_info};
}

1;
__END__

=head1 NAME

DBIx::Class::TimeStamp::Auto -

=head1 SYNOPSIS

  use DBIx::Class::TimeStamp::Auto;

=head1 DESCRIPTION

DBIx::Class::TimeStamp::Auto is

=head1 AUTHOR

Ryuta Kamizono E<lt>kamipo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
