package Niget::Web::Controller::API;
use Niget::ActiveRecord;
use Niget::Utils;

use parent 'Catalyst::Controller';

sub auto :Private {
    my ( $self, $c ) = @_;
    
    delete $c->stash->{$_} for keys %{$c->stash()};#->{videos};
    #delete $c->stash->{videos};
    $c->stash(
        #videos => 0,
        #reserves => 0,
    );
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(page_title => 'ニコニコ動画をダウンロード！');
}

sub create_comment :Local :Args(0) {
    my ($self, $c) = @_;

    my $result = Comment->add($c->req->params);

    $c->stash(
        result => $result
    )
}

sub get_comment :Local :Args(0) {
    my ($self, $c) = @_;

    my $result = Comment->get($c->req->params);

    $c->stash(
        result => $result
    )
}

sub end :Private {
    my ( $self, $c ) = @_;
    $c->forward('View::JSON');
}

1;
