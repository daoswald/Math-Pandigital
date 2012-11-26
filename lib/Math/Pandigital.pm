package Math::Pandigital;

use Any::Moose;

use strict;
use warnings;

use Carp;

our $VERSION = '0.01';

has base   => ( is => 'ro', isa => 'Int',  default => sub { 10; } );
has unique => ( is => 'ro', isa => 'Bool', default => sub { 0;  } );
has zero   => ( is => 'ro', isa => 'Bool', default => sub { 1;  } );

has _digits_array => (
  is      => 'ro',
  isa     => 'ArrayRef',
  lazy    => 1,
  builder => '_build_digits_array'
);

has _digits_charclass => (
  is      => 'ro',
  isa     => 'RegexpRef',
  lazy    => 1,
  builder => '_build_digits_charclass'
);

has _min_length => (
  is      => 'ro',
  isa     => 'Int',
  lazy    => 1,
  builder => '_build_min_length'
);

sub _build_digits_array {
  my $self  = shift;
  my $start = $self->zero ? 0 : 1;
  my $base  = $self->base;
  my $set;
  if( $base > 0 && $base <= 10 ) {
    $set = [ $start .. $self->base - 1 ];
  }
  elsif( $base == 16 ) {
    $set = [ $start .. 9, 'A' .. 'F' ];
  }
  else {
    croak "Valid bases are 1 through 10 and 16."
  }
  return $set;
}

sub _build_digits_charclass {
  my $self = shift;
  my $charclass_str = join( '', '[', @{ $self->_digits_array() }, ']' );
  return qr/$charclass_str/;
}

sub _build_min_length {
  my $self = shift;

  # Calculate the minimum possible input length for $value to qualify.
  return $self->base - ( $self->zero ? 0 : 1 );
}

sub is_pandigital {
  my ( $self, $value ) = @_;

  return if not $self->_length_ok( $value );

  return if not $self->_chars_ok( $value );

  return $self->_count_ok( $value );

}



sub _length_ok {
  my( $self, $value ) = @_;

  my $min_length = $self->_min_length;

  # Not pandigital if length is too short to contain all digits from base.
  return if length $value < $min_length;

  # Not pandigital if digits are unique, and length exceeds number
  # of base digits.
  return if $self->unique && length $value > $min_length;

  return 1;
}

sub _chars_ok {
  my( $self, $value ) = @_;

  # Reject if $value contains characters that are illegal for given base.
  my $re = $self->_digits_charclass;
  return $value =~ m/^${re}+$/;
}

sub _count_ok {
  my( $self, $value ) = @_;
  
  # Count occurrences of each digit in $value.
  my %hash;
  @hash{ @{ $self->digits_array } } = ();
  for my $digit ( split //, $value ) {
    # If uniqueness is required, NOT pandigital if input has repeated digits.
    return if ++$hash{$digit} > 1 && $self->unique;
  }

  # Only pandigital if every digit in 'base' was touched at least once.
  return keys %hash == $self->min_length;
}

__PACKAGE__->meta->make_immutable();


1;
