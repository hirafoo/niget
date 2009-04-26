package Niget::API::Account;
use base qw/Niget::API::Base::DBIC Niget::API::Base::Common/;
use Niget::ActiveRecord;
use Niget::Utils;

use YAML::Syck;

sub register_user {
    my $self = shift;

    my $accounts = LoadFile("$Niget::CONFIG_PATH/account.yaml")
        or die qq{set 'mail' and 'password' in '$Niget::CONFIG_PATH/account.yaml'\n};

    for my $account (@$accounts) {
        if ($account->{mail} and my $data = $self->find_by(mail => $account->{mail})) {
            print "already user exists. update the data using account.yaml\n";
            $data->update($account);
        }
        elsif ($account->{mail} and $account->{password}) {
            $self->create($account);
        }
    }

}

1;
