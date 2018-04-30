package PMLTQ::Command::printtrees;

# ABSTRACT: generate svg trees for given treebank

use PMLTQ::Base 'PMLTQ::Command';
use PMLTQ;
use File::Which;
use File::Path qw( make_path );

has usage => sub { shift->extract_usage };

my %opts;

sub run {
  my $self = shift;
  my @args = @_;
  my $tree_dir = $config->{tree_dir};

  ($ENV{BTRED} && -f $ENV{BTRED} ) || which('btred') || die 'path to btred is not in BTRED variable or in PATH';
  my $btred = $ENV{BTRED} || which('btred');

  unless ( @{ $config->{layers} } > 0 ) {
    print STDERR 'Nothing to print, no layers configured';
    return;
  }
  unless ( -d $tree_dir ) {
    make_path($tree_dir) or die "Unable to create directory $tree_dir\n";
    print "Path '$tree_dir' has been created\n";
  }
  for my $layer ( @{ $config->{layers} } ) {
    for my $file ( $self->files_for_layer($layer) ) {
      my ($img_name,$img_dir) = fileparse($file,qr/\.[^\.]*/);
      $img_dir =~ s/$data_dir/$tree_dir/;
      make_path($img_dir) if ($img_dir && !(-d $img_dir));
      print STDERR "$data_dir\t$img_dir/$img_name\n";
      $self->generate_trees($file,File::Spec->catfile($img_dir,$img_name));

    }

  }


  return 1;
}

sub generate_trees {
	my ($self, file_in, $file_out) = @_;
	print STDERR "TODO generate_trees($file_in,$file_out)\n";
}
sub files_for_layer {
  my ( $self, $layer ) = @_;

  if ( $layer->{data} ) {
    return glob( File::Spec->catfile( $self->config->{data_dir}, $layer->{data} ) );
  } elsif ( $layer->{filelist} ) {
    return $self->load_filelist( $layer->{filelist} );
  }
}

sub load_filelist {
  my ( $self, $filelist ) = @_;

  die "Filelist '$filelist' does not exists or is not readable!" unless -r $filelist;

  map { File::Spec->file_name_is_absolute($_) ? $_ : File::Spec->catfile( $self->config->{data_dir}, $_ ) }
    grep { $_ !~ m/^\s*$/ } read_file( $filelist, chomp => 1, binmode => ':utf8' );
}

=head1 SYNOPSIS

  pmltq printtrees 

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
