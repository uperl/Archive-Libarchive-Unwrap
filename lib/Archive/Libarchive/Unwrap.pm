package Archive::Libarchive::Unwrap;

use strict;
use warnings;
use Archive::Libarchive qw( ARCHIVE_OK ARCHIVE_WARN ARCHIVE_EOF );
use Ref::Util qw( is_ref );
use 5.020;
use Carp ();
use experimental qw( signatures );

# ABSTRACT: Unwrap files with multiple compression / encoding formats
# VERSION

=head1 SYNOPSIS

# EXAMPLE: examples/synopsis.pl

=head1 DESCRIPTION

=head1 CONSTRUCTOR

=head2 new

=over 4

=item filename

=item memory

=back

=cut

sub new ($class, %options)
{
  Carp::croak("Required option: One of filename or memory")
    unless defined $options{filename} || defined $options{memory};

  Carp::croak("Missing or unreadable: $options{filename}")
    if defined $options{filename} && !-r $options{filename};

  my $self = bless {
    filename => delete $options{filename},
    memory   => delete $options{memory},
  }, $class;

  Carp::croak("Illegal options: @{[ sort keys %options ]}")
    if %options;

  return $self;
}

=head1 METHODS

=head2 unwrap

=cut

sub unwrap ($self)
{
  my $r = Archive::Libarchive::ArchiveRead->new;
  $r->support_filter_all;
  $r->support_format_raw;
  my $ret;
  if($self->{filename})
  {
    $ret = $r->open_filename($self->{filename});
  }
  elsif($self->{memory})
  {
    $ret = $r->open_memory(is_ref $self->{memory} ? $self->{memory} : \$self->{memory});
  }
  else
  {
    # this shouldn't happen if the constructor
    # is doing its job.
    die "internal error, no filename or memory";
  }

  $self->_diag($r, $ret);
  $ret = $r->next_header(Archive::Libarchive::Entry->new);
  $self->_diag($r, $ret);

  my $output = '';
  my $buffer;
  while(1)
  {
    $ret = $r->read_data(\$buffer);
    last if $ret == 0;
    $self->_diag($r, $ret);
    $output .= $buffer;
  }

  $ret = $r->close;
  $self->_diag($r, $ret);

  return $output;
}

sub _diag ($self, $r, $ret)
{
  if($ret == ARCHIVE_WARN)
  {
    Carp::carp($r->error_string);
  }
  elsif($ret < ARCHIVE_WARN)
  {
    Carp::croak($r->error_string);
  }
}

1;
