package Niget::Schema::Comment;
use Niget::Utils;

__PACKAGE__->resultset_class('Niget::ResultSet::Comment');
__PACKAGE__->resultset_attributes({
    alias => 'comment',
    from  => [{comment => 'comments'}],
    cache => 1,
    where => {'comment.deleted' => 0},
    order_by => 'comment.created_at DESC',
    prefetch => [qw/video/],
});

belongs_to 'video';

package Niget::ResultSet::Comment;
use Niget::Utils;
use parent 'DBIx::Class::ResultSet';

sub page {
    my $self = shift;

    $self->{attrs}{rows} ||= 10;
    $self->next::method(@_);
}

1;
