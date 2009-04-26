package Niget::Schema::Reserve;
use Niget::Utils;

__PACKAGE__->resultset_class('Niget::ResultSet::Reserve');
__PACKAGE__->resultset_attributes({
    alias => 'reserve',
    from  => [{reserve => 'reserves'}],
    cache => 1,
    where => {'reserve.deleted' => 0},
    order_by => 'reserve.created_at DESC',
#    prefetch => [qw/videos/],
});

#has_many 'videos';

package Niget::ResultSet::Reserve;
use Niget::Utils;

use parent 'DBIx::Class::ResultSet';

sub page {
    my $self = shift;

    $self->{attrs}{rows} ||= 10;
    $self->next::method(@_);
}

1;
