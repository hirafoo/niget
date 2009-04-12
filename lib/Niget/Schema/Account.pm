package Niget::Schema::Account;
use Niget::Utils;

__PACKAGE__->resultset_class('Niget::ResultSet::Account');
__PACKAGE__->resultset_attributes({
    alias => 'account',
    from  => [{account => 'accounts'}],
    cache => 1,
    where => {'account.deleted' => 0},
});

package Niget::ResultSet::Account;
use Niget::Utils;

use parent 'DBIx::Class::ResultSet';

1;
