#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use File::Spec;
#use lib File::Spec->catfile( $FindBin::Bin, qw/.. schema lib/ );

use Path::Class qw/file dir/;
use DBIx::Class::Schema::Loader qw/make_schema_at/;

die "args: MyApp dsn user password\n".
    "ex: ./script/schema_dumper.pl MyApp 'dbi:mysql:myapp:127.0.0.1:3306' 'db_user' 'db_pass'\n" unless @ARGV;

my $app = shift @ARGV;

# do manual delete instead of really_erase_my_files option
#    for keep MyApp/Schema.pm
my $libdir = dir($FindBin::Bin, '..', 'lib', $app, 'Schema' );
if (-d $libdir) {
    $libdir->rmtree;
}

make_schema_at(
    "$app\::Schema",
    {
        skip_relationships => 0,
        debug => 0,
        # db_schema
        # constraint
        exclude => qr/^(?:schema_migrations|sessions)$/,
        # moniker_map => sub { shift->singularize->camelize },
        # inflect_plural
        inflect_singular => sub { (my $col = shift) =~ s/_id$//; $col },
        # additional_base_classes
        # left_base_classes
        # additional_classes
        # components => [qw/InflateColumn::DateTime ResultSetManager/],
        # resultset_components => [qw/ResultSet::FixedJoin/],
        # use_namespaces
        dump_directory => File::Spec->catfile( $FindBin::Bin, '..', 'lib' ),
        # dump_overwrite
        really_erase_my_files => 1,
    },
    \@ARGV,
);

1;
