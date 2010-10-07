use strict;
use warnings;
use Test::More tests => 16;

eval 'use JSON::XS';
plan skip_all => 'Install JSON::XS to run this test' if ($@);

BEGIN {
	use_ok( 'Catalyst::Model::REST::Serializer' );
}

my %resultdata = (
	'application/json' => '{"foo":"bar"}',
	'application/xml' => '<opt foo="bar" />'."\n",
	'application/yaml' => "---\nfoo: bar\n",
);
for my $type (qw{application/json application/xml application/yaml}) {
	my $data = {foo => 'bar'};
	ok (my $serializer = Catalyst::Model::REST::Serializer->new(type => $type), "New $type serializer");
	is($serializer->content_type, $type, 'Content Type');
	ok(my $sdata = $serializer->serialize($data), 'Serialize');
	is($sdata, $resultdata{$type}, 'Serialize data');
	is_deeply($serializer->deserialize($sdata), $data, 'Deserialize');
}