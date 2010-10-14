package Niget::API::Comment;
use base qw/Niget::API::Base::DBIC Niget::API::Base::Common/;
use Niget::ActiveRecord;
use Niget::Utils;

sub add {
    my ($self, $params) = @_;

    my ($video_id, $comment) = ($params->{video_id}, $params->{comment});
    my $video = Video->find_by(id => $video_id);
    ($video and $comment) or return 0;

    Comment->create({
        video_id => $video_id,
        content => $comment,
    });

    return 1;
}

1;
