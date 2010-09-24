package Catalyst::Model::REST::Serializer;
use 5.010;
use Moose;

our %types = (
	json => {
		content_type => 'application/json',
		package => 'Catalyst::Model::REST::Serializer::JSON',
	},
	yaml => {
		content_type => 'application/yaml',
		package => 'YAML::Syck',
	},
);

sub BUILD {
    my ($self, $args) = @_;
    my $type = $args->{type} or return;
    my $package = $types{$type}{package} or return;
    eval "require $package";
    return $package->new;
}

1;