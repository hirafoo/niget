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
use Encode qw/encode_utf8/;

use URI::Escape;

sub add {
    my ($self, $class, $params, $data) = @_;

    my $qr = qr{^http://www\.nicovideo\.jp/watch/[sn]m};
    my $valid = FormValidator::Simple->check($params => [
        url => ['NOT_BLANK', 'HTTP_URL', ['REGEX', $qr]],
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

    while (my $n = $reserves->next) {
        $n->update({visible => 0});
    }
    $reserves->reset;

    while (my $r = $reserves->next) {
        say "reserve_id: " . $r->id;
        say "url: " . $r->url;

        my $video_url = $r->url;
        $video_url =~ m{/(\w{0,2}\d+)};
        my $video_id = $1;

        my ($url_economy, $url_premium) = ('', '');
        while (my $account = $accounts->next) {
            say "account: " . $account->mail;

            my $login_data = {
                mail     => $account->mail,
                password => $account->password,
            };

            say "login niconico";
            $ua->post( "https://secure.nicovideo.jp/secure/login?site=niconico" => $login_data );
            say "get once";
            $ua->get($video_url);

            my $api_video_url = "http://flapi.nicovideo.jp/api/getflv/$video_id";
            say "get: $api_video_url";
            my $res = $ua->get($api_video_url);
            my $q   = CGI->new( $res->content );
            $video_url = $q->param('url');

            if ($account->is_premium) {
                say "premium";
                $url_premium = $video_url;
            }
            else {
                say "economy";
                $url_economy = $video_url;
            }

            unless ($video_url) {
                p "failed to get video info: " . $res->content. "delete this data.";
                $r->update({deleted => 2});
                next;
            }
            say "next account";
        }
        $accounts->reset;

        my $api_thumb_url = "http://ext.nicovideo.jp/api/getthumbinfo/$video_id";
        say "get: $api_thumb_url";
        my $name = $ua->get($api_thumb_url);
        my $xml = XMLin($name->content);
        $name = $xml->{thumb}->{title};
        $name = encode_utf8($name) || '名前の取得に失敗しました。。。';
        my $thumbnail_url = $xml->{thumb}->{thumbnail_url} || '';

        eval {
            Video->create({
                reserve_id    => $r->id,
                name          => $name,
                url_economy   => $url_economy,
                url_premium   => $url_premium,
                thumbnail_url => $thumbnail_url,
            });
        };

        say "sleep";
        sleep 60;
    }
}

1;
