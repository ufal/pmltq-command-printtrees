use strict;
use warnings;
use Test::Most;
use File::Which;
use File::Spec;
use File::Basename qw/dirname basename/;
use lib File::Spec->rel2abs( File::Spec->catdir( dirname(__FILE__),File::Spec->updir, File::Spec->updir, 'lib' ) );
use Capture::Tiny ':all';
use PMLTQ::Command::printtrees;
use PMLTQ::Commands;

is(which('btred'),undef,'btred is not in $PATH'); # make sure that btred is not in path
is($ENV{BTRED},undef,'btred is not in $ENV{BTRED}');# make sure that btred is not in $ENV{BtRED}
dies_ok { PMLTQ::Command::printtrees->new(config => {})->run() } "calling printtrees without btred";

my $btred_path = '/opt/tred/btred';

my $h =  capture_merged { 
	lives_ok { PMLTQ::Command::printtrees->new(config => {printtrees=>{btred=>$btred_path}})->run() } "calling printtrees with btred";
};
like($h,"/no layers/","no layers is set");




done_testing();
