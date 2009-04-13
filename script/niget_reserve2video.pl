#!/usr/bin/perl
$ENV{SUFFIX} ||= 'development';
use lib './lib';
use Niget;
use Niget::ActiveRecord;
use Niget::CLI;
use Niget::Utils;

Reserve->reserve2video;
