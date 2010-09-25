package Catalyst::Model::REST::Serializer::YAML;
use 5.010;
use Moose::Role;

use YAML::Syck;

sub content_type { 'application/yaml' }

sub encode {
	my ($self,$data) = @_;
	Dump $data;
}

sub decode {
	my ($self,$data) = @_;
	Load $data;
}

no Moose::Role;

1;