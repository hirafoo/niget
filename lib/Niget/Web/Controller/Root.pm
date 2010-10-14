package Niget::Web::Controller::Root;
use Niget::ActiveRecord;
use Niget::Utils;

use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub auto :Private {
    my ( $self, $c ) = @_;
    
    $c->stash(
        is_dev   => $ENV{NIGET_WEB_CONFIG_LOCAL_SUFFIX} eq "development",
        videos   => Video->find_all_by(visible => 1),
        reserves => Reserve->find_all_by(visible => 1),
    );
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(page_title => 'ニコニコ動画をダウンロード！');
}

sub about :Local {
    my ( $self, $c ) = @_;
    $c->stash(page_title => '説明');
}

sub author :Local {
    my ( $self, $c ) = @_;
    $c->stash(page_title => '作った人たち');
}

sub watch :Local :Args(1) {
    my ($self, $c, $nico_id) = @_;

    $c->stash(
        nico_id    => $nico_id,
        page_title => 'ちょっと見る',
    )
}

sub jump :Local :Args(1) {
    my ($self, $c, $video_id) = @_;

    my $video = Video->find($video_id) or return $c->res->redirect('/');
    $c->res->redirect($video->reserve->url);
}

sub get :Local :Args(2) {
    my ($self, $c, $video_id, $mode) = @_;

    my $video = Video->find($video_id) or return $c->res->redirect('/');
    my $url = ($mode == 1) ? $video->url_economy :
              ($mode == 2) ? $video->url_premium :
              '/';
    $c->res->redirect($url);
}

sub default :Path {
    my ( $self, $c ) = @_;

    $c->stash(
        page_title => '？？？',
        template   => 'not_found.tt',
    );
}

sub end :Private {
    my ( $self, $c ) = @_;

    $c->forward('render');
    $c->fillform if $c->req->param;
}

sub render :ActionClass('RenderView') {}

1;
