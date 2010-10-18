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

    $video->update({comment_count => ($video->comment_count + 1)});

    return 1;
}

sub get {
    my ($self, $params) = @_;

    my $video_id = $params->{video_id} or return;
    my $data = Comment->search({video_id => $video_id});

    my @comments;
    while (my $comment = $data->next) {
        #push @comments, $comment->content;
        #push @comments, utf->encode($comment->content);
        push @comments, utf->decode($comment->content);
    }
    p \@comments;
    return \@comments;
}

1;
