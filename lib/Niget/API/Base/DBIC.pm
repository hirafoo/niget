package Niget::API::Base::DBIC;
use Niget;
use Niget::Utils;
use String::CamelCase qw/decamelize/;
use YAML::Syck;

sub new {
    my $class = shift;

    $class = ref $class || $class;
    bless { @_ }, $class;
}

sub class {
    my $self = shift;
    (split(/::/, ref $self))[-1];
}

sub resultset {
    my $self = shift;

    my $class = $self->class();
    my $schema = $Niget::SCHEMA;

    return $schema->resultset($class);
}

### DBIC CRUD

sub create {
    my ($self, $args) = @_;
    my $rs = $self->resultset();
    $rs->create($args);
}

# different from the original
sub find {
    my ($self,$id) = @_;
    my $rs = $self->resultset();
    $rs->find($id);
}

sub search {
    my ($self, $cond, $attrs) = @_;

    $cond  ||= {};
    $attrs ||= {};

    my $rs = $self->resultset();
    $rs->search_rs($cond, $attrs);
}

sub update {
    my ($self, $args) = @_;
    my $rs = $self->resultset();
    $rs->create($args);
}

sub delete {
    my $self = shift;
    my $rs = $self->resultset();
    $rs->delete;
}

### original

sub find_by {
    my ($self, %value) = @_;
    $self->find_all_by(%value)->next;
}

sub find_all_by {
    my ($self, %value) = @_;

    my $class = decamelize $self->class();
    my $result = $self->search;

    for my $column (keys %value) {
        $result = $result->search({"$class.$column" => $value{$column}});
    }

    return $result;
};

1;
