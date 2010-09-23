use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::Model::REST',
    AUTHOR              => 'Kaare Rasmussen <kaare@cpan.org>',
    VERSION_FROM        => 'lib/Catalyst/Model/REST.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/Model/REST.pm',
    PL_FILES            => {},
    PREREQ_PM => {
		  'Catalyst::Model'			=> 0,
		  'JSON::XS'				=> 0,
		  'LWP::UserAgent'			=> 0,
		  'HTTP::Request::Common'	=> 0,
		  'Test::More'				=> 0,

## Maybe these ??
		  'MRO::Compat'				=> 0,
		  'Carp'					=> 0,
		  'URI'						=> 0,
		  'Class::Accessor'			=> 0,
		 },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Model-REST-*' },
);
