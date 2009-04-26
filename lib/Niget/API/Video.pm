package Niget::API::Video;
use base qw/Niget::API::Base::DBIC Niget::API::Base::Common/;
use Niget::ActiveRecord;
use Niget::Utils;

use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Request;
use HTTP::Headers;
use CGI;
use Crypt::SSLeay;

sub reget_url {
    my $self = shift;

    my $videos = $self->search;
    my %account;
    $account{economy} = Account->find_by(is_premium => 0);
    $account{premium} = Account->find_by(is_premium => 1);

    while (my $video = $videos->next) {
        my $video_url = $video->reserve->url;
        $video_url =~ m{/(\w{0,2}\d+)};
        my $video_id = $1;

        my ($url_economy, $url_premium) = ('', '');

        for my $k (keys %account) {
            my $login_data = {
                mail     => $account{$k}->mail,
                password => $account{$k}->password,
            };

            my $ua = LWP::UserAgent->new( keep_alive => 4 );
            $ua->cookie_jar( {} );
            $ua->post( "https://secure.nicovideo.jp/secure/login?site=niconico" => $login_data );
            $ua->get($video_url);

            my $res = $ua->get("http://www.nicovideo.jp/api/getflv?v=$video_id");
            my $q   = CGI->new( $res->content );
            $video_url = $q->param('url') || '';

            $video->update({"url_$k" => $video_url})
                if $video_url;
        }
        sleep 60;
    }
}

1;
