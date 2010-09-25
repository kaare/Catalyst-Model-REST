use strict;
use warnings;
use Test::More tests => 6;

eval 'use YAML::Syck';
plan skip_all => 'Install YAML::Syck to run this test' if ($@);

BEGIN {
	use_ok( 'Catalyst::Model::REST::Serializer' );
}

my $role = 'Catalyst::Model::REST::Serializer::YAML';
my $type = 'yaml';
my $data = {foo => 'bar'};
ok (my $serializer = Catalyst::Model::REST::Serializer->with_traits($role)->new(type => $type), 'New yaml serializer');
is($serializer->content_type, 'application/yaml', 'Content Type');
ok(my $yaml = $serializer->encode($data), 'Encode');
is($yaml, "--- \nfoo: bar\n", 'Encode data');
is_deeply($serializer->decode($yaml), $data, 'Decode');
