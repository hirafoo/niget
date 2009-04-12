package Niget::Schema::Video;
use Niget::Utils;

__PACKAGE__->resultset_class('Niget::ResultSet::Video');
__PACKAGE__->resultset_attributes({
    alias => 'video',
    from  => [{video => 'videos'}],
    cache => 1,
    where => {'video.deleted' => 0},
    order_by => 'video.created_at DESC',
    prefetch => [qw/reserve/],
});

belongs_to 'reserve';

package Niget::ResultSet::Video;
use Niget::Utils;

use parent 'DBIx::Class::ResultSet';

sub page {
    my $self = shift;

    $self->{attrs}{rows} ||= 10;
    $self->next::method(@_);
}

1;
