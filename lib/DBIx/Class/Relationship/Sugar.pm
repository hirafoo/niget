package DBIx::Class::Relationship::Sugar;
use strict;
use warnings;

our $VERSION = '0.01.1';

use parent 'DBIx::Class::Relationship';
use autobox::String::Inflector;

sub might_have {
    my $class = caller;
    shift if $class eq $_[0];

    $class->next::method(@_);
}

sub has_one {
    my $class = caller;
    shift if $class eq $_[0];

    $class->next::method(@_);
}

sub _has_one {
    my ($class, $join_type, $rel, $f_class, $cond, $attrs) = @_;

    $f_class ||= $class->schema_class . '::' . $rel->camelize;
    $f_class   = $class->schema_class . $f_class if $f_class =~ /^::/;

    $cond ||= {"foreign.@{[$class->table->singularize]}_id" => 'self.id'};

    $class->next::method($rel, $f_class, $cond, $attrs);
}

sub belongs_to {
    my $class = caller;
    shift if $class eq $_[0];
    my ($rel, $f_class, $cond, $attrs) = @_;

    $f_class ||= $class->schema_class . '::' . $rel->camelize;
    $f_class   = $class->schema_class . $f_class if $f_class =~ /^::/;

    $class =~ m/([\w:]+)::\w+?$/;
    my $base_schema = $1;

    $cond ||= {id => "$rel\_id"};
    $f_class = $base_schema . $f_class;
    
    $class->next::method($rel, $f_class, $cond, $attrs);
}

sub has_many {
    my $class = caller;
    shift if $class eq $_[0];
    my ($rel, $f_class, $cond, $attrs) = @_;

    $f_class ||= $class->schema_class . '::' . $rel->singularize->camelize;
    $f_class   = $class->schema_class . $f_class if $f_class =~ /^::/;

    $class =~ m/([\w:]+)::\w+?$/;
    my $base_schema = $1;

    $cond ||= {"foreign.@{[$class->table->singularize]}_id" => 'self.id'};
    $f_class = $base_schema . $f_class;

    $class->next::method($rel, $f_class, $cond, $attrs);
}

sub many_to_many {
    my $class = caller;
    shift if $class eq $_[0];
    my ($meth, $rel, $f_rel, $rel_attrs) = @_;

    $f_rel ||= $meth->singularize;

    $class->next::method($meth, $rel, $f_rel, $rel_attrs);
}

sub schema_class {ref shift->result_source_instance->schema}

=head1 NAME

DBIx::Class::Relationship::Sugar - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

  use DBIx::Class::Relationship::Sugar;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Ryuta Kamizono <kamipo@gmail.com>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
