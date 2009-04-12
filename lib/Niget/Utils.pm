package Niget::Utils;
use strict;
use warnings;

use DateTime;
use Data::Dumper;

sub import {
    my $class = shift;
    my $pkg   = caller;

    strict->import;
    warnings->import;

    no strict 'refs';
    *{"$pkg\::p"} = \&p;
    *{"$pkg\::now"} = \&now;
}

sub p { 
    warn Dumper shift;# if $ENV{CATALYST_DEBUG} or $ENV{P_DEBUG};
}

my $tz = DateTime::TimeZone->new( name => 'local' );
sub now { DateTime->now(time_zone => $tz) }
    
1;
