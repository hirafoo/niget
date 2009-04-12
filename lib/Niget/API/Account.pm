package Niget::API::Account;
use base qw/Niget::API::Base::DBIC Niget::API::Base::Common/;
use Niget::ActiveRecord;
use Niget::Utils;

use YAML::Syck;

sub register_user {
    my $self = shift;

    my $conf = LoadFile("$Niget::CONFIG_PATH/account.yaml");

    if ($conf->{mail} and my $data = $self->find_by(mail => $conf->{mail})) {
        print "already user exists. update the data using account.yaml\n";
        return $data->update($conf);
    }
    elsif ($conf->{mail} and $conf->{password}) {
        return $self->create($conf);
    }

    die qq{set 'mail' and 'password' in '$Niget::CONFIG_PATH/account.yaml'\n};
}

1;
