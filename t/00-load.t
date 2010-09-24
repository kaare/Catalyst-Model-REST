use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Model::REST' );
}

diag( "Testing Catalyst::Model::REST $Catalyst::Model::REST::VERSION, Perl $], $^X" );
print STDERR "bef\n";
my $a = Catalyst::Model::REST->new(type => 'json');
print STDERR "xxx\n";
print ref $a->serializer;
print STDERR "aft\n";
