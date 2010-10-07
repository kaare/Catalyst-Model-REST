package Catalyst::Model::REST::Serializer;
use 5.010;
use Moose;
use Moose::Util::TypeConstraints;

with 'Data::Serializable';

has 'type' => (
    isa => enum ([qw{application/json application/xml application/yaml}]),
    is  => 'rw',
	default => 'application/json',
	trigger   => \&_set_module
);
no Moose::Util::TypeConstraints;

no Moose;

our %modules = (
	'application/json' => {
		module => 'JSON',
	},
	'application/xml' => {
		module => 'XML::Simple',
	},
	'application/yaml' => {
		module => 'YAML',
	},
);

sub _set_module {
	my ($self, $type) = @_;
	$self->serializer_module($modules{$type}{module});
}

sub content_type {
	my ($self) = @_;
	return $self->type;
}

1;