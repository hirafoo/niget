package Niget::API::Reserve;
use base qw/Niget::API::Base::DBIC Niget::API::Base::Common/;
use Niget::ActiveRecord;
use Niget::Utils;

use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Request;
use HTTP::Headers;
use CGI;
use Crypt::SSLeay;
use XML::Simple;
use Encode;

use URI::Escape;

sub add {
    my ($self, $class, $params, $data) = @_;

    my $valid = FormValidator::Simple->check($params => [
        url => ['NOT_BLANK', 'HTTP_URL', ['REGEX', qr{^http://www\.nicovideo\.jp/watch/}]],
    ]);

    my $msg;
    if ($valid->has_error) {
        $msg = '何か変なURLだよ！';
    }
    else {
        my $exists = $self->find_by(url => $params->{url});

        if ($exists) {
            $msg = '登録済みだから探して！既にビデオの方にあるかも！';
        }
        else {
            $self->create( $params );
            $msg = '追加したから5分待って！';
        }
    }

    return {
        msg => $msg,
    };
}

sub reserve2video {
    my $self = shift;

    my $accounts = Account->search;
    unless ($accounts->count) {
        die qq{there is no account data.\n}.
            qq{at first, create account data by './script/niget_register_account.pl'\n};
    }

    my $ua = LWP::UserAgent->new( keep_alive => 4 );
    $ua->cookie_jar( {} );

    my $reserves = $self->find_all_by(visible => 1);
    $reserves->update({visible => 0});
    while (my $r = $reserves->next) {
        my $video_url = $r->url;
        $video_url =~ m{/(\w{0,2}\d+)};
        my $video_id = $1;

        my ($url_economy, $url_premium) = ('', '');
        while (my $account = $accounts->next) {

            my $login_data = {
                mail     => $account->mail,
                password => $account->password,
            };

            $ua->post( "https://secure.nicovideo.jp/secure/login?site=niconico" => $login_data );
            $ua->get($video_url);

            my $res = $ua->get("http://www.nicovideo.jp/api/getflv?v=$video_id");
            my $q   = CGI->new( $res->content );
            $video_url = $q->param('url');

            if ($account->is_premium) {
                $url_premium = $video_url;
            }
            else {
                $url_economy = $video_url;
            }

            unless ($video_url) {
                p "failed to get video info: " . $res->content. "delete this data.";
                $r->update({deleted => 2});
                next;
            }
            sleep 60;
        }
        $accounts->reset;

        my $name = $ua->get("http://ext.nicovideo.jp/api/getthumbinfo/$video_id");
        my $xml = XMLin($name->content);
        $name = $xml->{thumb}->{title};
        $name = encode('utf-8',$name) || '名前の取得に失敗しました。。。';
        my $thumbnail_url = $xml->{thumb}->{thumbnail_url} || '';

        Video->create({
            reserve_id    => $r->id,
            name          => $name,
            url_economy   => $url_economy,
            url_premium   => $url_premium,
            thumbnail_url => $thumbnail_url,
        });
    }
}

1;
