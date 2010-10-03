package Catalyst::Model::REST::Serializer;
use 5.010;
use Moose;
use Moose::Util::TypeConstraints;

with 'Data::Serializable';

has 'type' => (
    isa => enum ([qw/json xml yaml/]),
    is  => 'rw',
	default => 'json',
	trigger   => \&_set_module
);
no Moose::Util::TypeConstraints;

no Moose;

our %modules = (
	json => {
		module => 'JSON',
		content_type => 'application/json',
	},
	xml => {
		module => 'XML::Simple',
		content_type => 'application/xml',
	},
	yaml => {
		module => 'YAML',
		content_type => 'application/yaml',
	},
);

sub _set_module {
	my ($self, $type) = @_;
	$self->serializer_module($modules{$type}{module});
}

sub content_type {
	my ($self) = @_;
	return $modules{$self->type}{content_type};
}

1;