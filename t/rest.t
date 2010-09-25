use Test::More tests => 4;

BEGIN {
	use_ok( 'Catalyst::Model::REST' );
}

diag( "Testing Catalyst::Model::REST $Catalyst::Model::REST::VERSION, Perl $], $^X" );
ok(my $rest = Catalyst::Model::REST->new(type => 'json', server => 'http://localhost:3000'), 'Create REST instance');
isa_ok($rest, 'Catalyst::Model::REST', 'REST');
isa_ok($rest->serializer, 'Catalyst::Model::REST::Serializer', 'JSON serializer');
