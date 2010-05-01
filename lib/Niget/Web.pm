package Niget::Web;
use Niget;
use Niget::Utils;
use Niget::Schema;
use Encode qw/find_encoding/;

use Catalyst::Runtime '5.70';
use parent qw/Catalyst/;
use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    FillInForm
/;

our $VERSION = '0.01';
__PACKAGE__->config(
    'Plugin::ConfigLoader' => {file => __PACKAGE__->path_to($Niget::CONFIG_PATH)}
);

sub setup {
    my $self = shift;

    $self->SUPER::setup(@_);

    my $connect_info = __PACKAGE__->config->{'Model::DBIC'}->{connect_info};
    $Niget::SCHEMA = Niget::Schema->connection(@$connect_info);
    $Niget::UTF = find_encoding('utf-8');
}

__PACKAGE__->setup();

package Catalyst::Utils;

no warnings 'redefine';

=head2 class2prefix

before : HogeFuga -> hogefuga
after  : HogeFuga -> hoge_fuga

=cut

sub class2prefix {
    my $class = shift || '';
    my $case  = shift || 0;
    my $prefix;
    if ( $class =~ /^.+?::([MVC]|Model|View|Controller)::(.+)$/ ) {
        $prefix = $case ? $2 : do {
            $prefix = $2;
            $prefix =~ s{([A-Z][a-z0-9]+)}{_$1}g;
            $prefix =~ s{([A-Z][A-Z]+)}{_$1}g;
            $prefix =~ s{(^|::)_(_*)([A-Z]+[a-z0-9]*)}{$1$2$3}g;
            lc $prefix;
        };
        $prefix =~ s{::}{/}g;
    }
    return $prefix;
}

1;
