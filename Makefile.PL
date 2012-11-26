## no critic (RCS,VERSION)

use strict;
use warnings;

use ExtUtils::MakeMaker;

## no critic (may require interpolation)
WriteMakefile(
    NAME               => 'Math::Pandigital',
    AUTHOR             => q{David Oswald <davido [@at] cpan [d.o.t] org>},
    VERSION_FROM       => 'lib/Math/Pandigital.pm',
    ABSTRACT_FROM      => 'lib/Math/Pandigital.pm',
    LICENSE            => 'perl',
    MIN_PERL_VERSION   => '5.006000',
    PL_FILES           => {},
    BUILD_REQUIRES => {
        'Test::More' => '0.98',             # Core, but updated version.
        'English'    => '0',                # Core.
    },
    PREREQ_PM => {
        'Set::Scalar' => '0',
    },
    META_MERGE => {
        provides => {
            'Math::Pandigital' => {
                file    => 'lib/Math/Pandigital.pm',
                version => '0.01'
            },
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Math-Pandigital-*' },
);
