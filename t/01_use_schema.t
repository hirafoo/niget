#!/bin/perl
use Niget::ActiveRecord;
use Niget::Test::Base qw/no_plan/;

is ('Niget::API::Video', ref Video, 'like ActiveRecord');
is ('Niget::API::Reserve', ref Reserve, 'like ActiveRecord');


run_tests;
__END__

=== i is e ?
--- i
2
--- e
2
