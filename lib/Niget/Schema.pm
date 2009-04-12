package Niget::Schema;
use Niget::Utils;

use parent 'DBIx::Class::Schema::Loader';
use Data::Page::Navigation;
use autobox::String::Inflector;
use DateTime;
use DBIx::Class::TimeStamp::Auto {
    auto_create_datetime_columns => [qw/created_at/],
    auto_update_datetime_columns => [qw/updated_at/],
    datetime_timezone => DateTime::TimeZone->new(name => 'local'),
};

__PACKAGE__->loader_options(
    components => [qw/TimeStamp::Auto Relationship::Sugar/],
    additional_base_classes => [qw/DBIx::Class::WebForm/],
    exclude => qr/^(?:schema_migrations)$/,
    moniker_map => sub { shift->singularize->camelize },
    skip_relationships => 1,
);

package DBIx::Class::ResultSet;
use Niget::Utils;

use DBIx::Class::ResultClass::HashRefInflator;

sub as_hashref {
    my $self = shift;

    $self->result_class('DBIx::Class::ResultClass::HashRefInflator');
    wantarray ? $self->all : $self;
}

sub create_from_form {
    my ($self, $results) = @_;

    local *DBIx::Class::WebForm::create = sub {
        my ($class, $cols) = @_;
        $self->create($cols);
    };

    $self->result_class->create_from_form($results);
}

1;
