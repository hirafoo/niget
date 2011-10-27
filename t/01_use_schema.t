#!/bin/perl
use Niget;
use Niget::ActiveRecord;
use Niget::CLI;
use Niget::Test::Base qw/no_plan/;

my @classes = qw/Account Reserve Video/;

no strict 'refs';
# Hoge eq Niget::API::Hoge->new ?
is ("Niget::API::$_", ref &$_, 'like ActiveRecord')
    for @classes;
# Niget::API::Hoge->class eq Hoge ?
is ($_, &$_->class, 'class')
    for @classes;
# Niget::API::Hoge->resultset eq Niget::ResultSet::Hoge ?
is ("Niget::ResultSet::$_", ref &$_->resultset, 'resultset(org)')
    for @classes;
