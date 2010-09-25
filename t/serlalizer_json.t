use strict;
use warnings;
use Test::More tests => 6;

eval 'use JSON::XS';
plan skip_all => 'Install JSON::XS to run this test' if ($@);

BEGIN {
	use_ok( 'Catalyst::Model::REST::Serializer' );
}

my $role = 'Catalyst::Model::REST::Serializer::JSON';
my $type = 'json';
my $data = {foo => 'bar'};
ok (my $serializer = Catalyst::Model::REST::Serializer->with_traits($role)->new(type => $type), 'New JSON serializer');
is($serializer->content_type, 'application/json', 'Content Type');
ok(my $json = $serializer->encode($data), 'Encode');
is($json, '{"foo":"bar"}', 'Encode data');
is_deeply($serializer->decode($json), $data, 'Decode');
