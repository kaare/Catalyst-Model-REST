package Catalyst::Model::REST::Serializer;
use 5.010;
use Try::Tiny;
use Moose;
use Moose::Util::TypeConstraints;

with 'Data::Serializable' => { -version => '0.40.1' };

has 'type' => (
    isa => enum ([qw{application/json application/xml application/yaml application/x-www-form-urlencoded}]),
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
	'application/x-www-form-urlencoded' => {
		module => 'FORM',
	},
);

sub _set_module {
	my ($self, $type) = @_;
	return unless $modules{$type};

	my $module = $modules{$type}{module};
	return $module if $module eq 'FORM';

	my $serializer;
	try {
		$serializer = $self->serializer_module($module);
	} catch {
		$serializer = undef;
	};
	return $serializer;
}

sub content_type {
	my ($self) = @_;
	return $self->type;
}

1;
