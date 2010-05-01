package Niget::API::Base::Common;
use Niget::ActiveRecord;
use Niget::Utils;
use String::CamelCase qw/camelize decamelize/;
use autobox::String::Inflector;
use FormValidator::Simple;

sub list {
    my ($self, $class, $params, $data) = @_;
    my $Class = camelize($class->singularize);
    my %params = %$params;

    my $page = delete $params{page} || 1;
    $data = $data->page($page);
    my $template = "$class/list.tt";

    if (%params) {
        $class = $class->singularize;
        map {
            my $v = $params{$_};
            if ($v) {
                my @words = split /\s+|\Q　\E/, $v;
                for my $w (grep /.+/, @words) {
                    $data = $data->search({"$class.$_" => {like => "\%$w%"}});
                }
            }
            delete $params{$_};# unless $v;
        } qw/name url/;

        my %attrs;
        $attrs{'order_by'} = "$class.created_at " . delete $params{date} if $params{date};
        $params{"date($class.created_at)"} = delete $params{day} if $params{day};
        for my $column (keys %params) {
            $data = $data->search({"$class.$column" => $params{$column}}, \%attrs);
        }
    }

    my $pager = $data->pager;

    return {
        data     => $data,
        pager    => $pager,
        template => $template,
    };
}

1;
