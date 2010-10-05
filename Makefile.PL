use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

perl_version '5.10.0';

name 'Catalyst-Model-REST';
all_from 'lib/Catalyst/Model/REST.pm';

requires 'Moose';
requires('Catalyst::Model'			=> '0');
requires('JSON::XS'					=> '2.2222');
requires('LWP::UserAgent'			=> '0');
requires('HTTP::Request::Common'	=> '0');
requires('Data::Serializable'		=> '0.40.1');

test_requires 'Test::More' => '0.88';

author_requires 'Test::Pod' => 1.14;
author_requires 'Module::Info';
author_requires 'File::Find::Rule';

feature 'YAML (application/yaml) support',
	-default   => 0,
	'JSON'     => '2.12';
	'YAML::Syck' => '0.67';

author_requires 'YAML::Syck' => '0.67';

auto_include;
auto_install;

if ($Module::Install::AUTHOR) {
	system("pod2text lib/Catalyst/Model/REST.pm > README")
		and die $!;
}

repository 'git://github.com/kaare/Catalyst-Model-REST.git';

WriteAll;

