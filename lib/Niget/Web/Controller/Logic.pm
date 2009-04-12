package Niget::Web::Controller::Logic;
use Niget::ActiveRecord;
use Niget::Utils;
use String::CamelCase qw/camelize decamelize/;
use autobox::String::Inflector;

use parent 'Catalyst::Controller';

sub class :Chained('/') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $class ) = @_;

    $c->stash(
        class => $class,
    );
}

sub list :Chained('class') :PathPart :Args(0) {
    my ($self, $c) = @_;

    my $class = $c->stash->{class};
    my $Class = camelize($class->singularize);

    my $params = $c->req->params;
    my $data   = $c->stash->{$class};

    my $result = Model($Class)->list($class, $params, $data);

    $c->stash( 
        page_title => '一覧',
        data     => $result->{data},
        pager    => $result->{pager},
        template => $result->{template},
    );
}

sub add :Chained('class') :PathPart :Args(0) {
    my ($self, $c) = @_;

    my $class = $c->stash->{class};
    my $Class = camelize($class->singularize);

    my $params = $c->req->params;
    my $data   = $c->stash->{$class};

    if ($c->req->method eq 'POST') {
        my $result = Model($Class)->add($class, $params, $data);

        return $c->stash(
            template => 'result.tt',
            msg      => $result->{msg},
        );
    }

    $c->stash(
        page_title => '追加',
        mode     => '追加',
        template => 'add.tt',
    );
}

sub edit :Chained('class') :PathPart :Args(1) {
    my ($self, $c) = @_;

    $c->stash(
        template => 'edit.tt',
    );
}

sub delete :Chained('class') :PathPart :Args(0) {
    my ($self, $c) = @_;

    $c->stash(
        template => 'delete.tt',
    )
}

1;
