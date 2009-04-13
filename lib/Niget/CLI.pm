package Niget::CLI;
use Niget;
use Niget::ActiveRecord;
use Niget::Utils;

use YAML::Syck;

sub config {
    my $app_path = $ENV{APP_PATH} || '';
    my $suffix = "_$ENV{SUFFIX}" || '';
    my $yaml = "$app_path$Niget::CONFIG_PATH/niget_web$suffix.yaml";
    my $config = LoadFile($yaml);
}

sub schema {
    my $db = config()->{'Model::DBIC'}->{connect_info};
    my $schema = Niget::Schema->connection(@$db);
}

my $resultset = sub {
    my $self = shift;

    my $class = $self->class();
    schema()->resultset($class);
};

no warnings 'redefine';
*Niget::API::Base::DBIC::resultset = $resultset;
use warnings 'redefine';

1;
