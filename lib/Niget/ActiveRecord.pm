package Niget::ActiveRecord;
use Niget::Utils;
use Niget::Schema;
use UNIVERSAL::require;

use base qw/Exporter/;

my @schemas;
use subs @schemas;
push @schemas, 'Model';
our @EXPORT = @schemas;

my %Model;

BEGIN {
    my $app_path = $ENV{APP_PATH} || '';
    my $path = $app_path . './lib/Niget/Schema';
    opendir my $dh, $path or die "$path : $!";
    for my $Class (grep !/^\.\.?/, readdir($dh)) {
        $Class =~ s/\.pm//;
        push @schemas, $Class;
        $Model{$Class} = undef;
        my $ref = sub { $Model{$Class} };
        no strict 'refs';
        *{$Class} = $ref;
    }
    closedir $dh;
}

sub import {
    __PACKAGE__->export_to_level(1, @_);

    for my $Class (keys %Model) {
        my $package = "Niget::API::$Class";
        $package->require or die;
        my $obj = $package->new;
        $Model{$Class} = $obj;
    }
}

sub Model {
    my $Class = shift;
    no strict 'refs';
    $Model{$Class};
}

1;
