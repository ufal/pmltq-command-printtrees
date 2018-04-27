package PMLTQ::Command::printtrees;

# ABSTRACT: generate svg trees for given treebank

use PMLTQ::Base 'PMLTQ::Command';
use PMLTQ;

has usage => sub { shift->extract_usage };

my %opts;

sub run {
  my $self = shift;
  my @args = @_;

  return 1;
}

=head1 SYNOPSIS

  pmltq print-trees 

=head1 DESCRIPTION

Generate svg trees for given treebank. It works on local PML files.

=head1 OPTIONS

=head1 PARAMS

=over 5

=item B<treebank_config>

Path to configuration file. If a treebank_config is --, config is readed from STDIN.

=back

=cut

1;
