package Catalyst::Model::REST::Serializer::JSON;
use 5.010;
use Moose::Role;

use JSON::XS;

sub BUILD {
	my $self = shift;
	$self->{json} = JSON::XS->new->utf8;
}

sub content_type { 'application/json' }

sub encode {
	my ($self, $data) = @_;
	$self->{json}->encode($data);
}

sub decode {
	my ($self, $data) = @_;
	$self->{json}->decode($data);
}

no Moose::Role;

1;