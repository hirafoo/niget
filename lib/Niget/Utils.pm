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
    *{"$pkg\::utf"} = \&utf;
    *{"$pkg\::say"} = \&say;
}

sub p {
    warn Dumper @_;
    my @c = caller;
    print STDERR "  at $c[1]:$c[2]\n\n"
}
sub say {
    print @_, "\n"
}

my $tz = DateTime::TimeZone->new( name => 'local' );
sub now { DateTime->now(time_zone => $tz) }
sub utf { $Niget::UTF }

1;
