package Catalyst::Model::REST::Response;
use 5.010;
use Moose;

has 'code' => (
    isa => 'Int',
    is  => 'ro',
);
has 'response' => (
    isa => 'Object',
    is  => 'ro',
);
has 'data' => (
    isa => 'HashRef',
    is  => 'ro',
);

__PACKAGE__->meta->make_immutable;

1;