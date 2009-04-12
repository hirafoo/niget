package Niget::Test::Base;
use Niget;
use Niget::Schema;
use Niget::Utils;

use Test::Base -Base;

#$ENV{DBIC_TRACE} = 1;

our @EXPORT = qw/
    p
    run_tests
/;

sub run_tests {
    #delimiters('###');
    run_is;
}

1;
