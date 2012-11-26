use Test::More;

BEGIN {
  my $status = eval 'use Math::Pandigital; 1;';
  diag "Test error: $@" if ! $status;
  ok( $status, 'use Math::Pandigital;' );
}

{
  my $p = new_ok( 'Math::Pandigital' );
  is( $p->base,    10, 'base defaults to 10.'           );
  is( $p->unique,  0,  'unique defaults to true.'       );
  is( $p->zero,    1,  'zero indexed defaults to true.' );
  is_deeply( $p->_digits_array, [ 0 .. 9 ], '_digits_array defaults to 0..9' );
  is( ref($p->_digits_charclass), 'Regexp', '_digits_charclass returns a regex.' );
  diag $p->_digits_charclass, "\n";
}

{
  my $p = Math::Pandigital->new( base => 2, unique => 1, zero => 1 );
  is( $p->base,   2,
      'Setting base to 2 in constructor propagates to accessor.' );
  is( $p->unique, 1,
      'Setting unique to true in constructor propagates to accessor.' );
  is( $p->zero, 1,
      'Setting zero to true in constructor propagates to accessor.' );
  is( ref $p->_digits_charclass, 'Regexp',
      '_digits_charclass returned an RE object.' );
  like( $p->_digits_charclass, qr/\[01\]/, 'Base-2 creates a "[01]" character class.' );
  is_deeply( $p->_digits_array, [0..1], '_digits_array returns 0, 1 for base 2. ' );
}



done_testing();
