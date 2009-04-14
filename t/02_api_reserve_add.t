#!/bin/perl
use Niget;
use Niget::CLI;
use Niget::ActiveRecord;
use Niget::Test::Base qw/no_plan/;

filters {
    input    => ['yaml', 'add'],
    expected => 'yaml',
};

sub add { Reserve->add('reserve', @_) }

run_is_deeply;

__END__

=== blank input
--- input
url: 
--- expected
msg: 何か変なURLだよ！

=== string input
--- input
url: hoge
--- expected
msg: 何か変なURLだよ！

=== not niconico url
--- input
url: http://www.example.com/
--- expected
msg: 何か変なURLだよ！

=== ok case
--- input
url: http://www.nicovideo.jp/watch/sm0000000
deleted: 2
--- expected
msg: 追加したから5分待って！

