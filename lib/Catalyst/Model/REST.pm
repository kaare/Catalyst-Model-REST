package Catalyst::Model::REST;
use 5.010;
use Moose;

extends 'Catalyst::Model';

use Carp qw(confess);
use JSON::XS;
use LWP::UserAgent;
use HTTP::Request::Common;

our $VERSION = '0.01';

has 'server' => (
    isa => 'Str',
    is  => 'rw',
);
has 'json' => (
    isa => 'Object',
    is  => 'ro',
	lazy    => 1,
	builder => '_build_json',
	init_arg   => undef,
);
has 'ua' => (
    isa => 'Object',
    is  => 'ro',
	lazy    => 1,
	builder => '_build_ua',
	init_arg   => undef,
);

sub _build_json {
    my ($self) = @_;
    $self->{json} = JSON::XS->new->utf8;
}

sub _build_ua {
    my ($self) = @_;
    $self->{ua} = LWP::UserAgent->new;

}

sub post {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = $self->ua->request(POST($uri, Content_Type => 'application/json', Content => $self->json->encode($data)));
	return $self->json->decode($res->content);
}

sub get {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = $self->ua->request(GET($uri, Content_Type => 'application/json', Content => $self->json->encode($data)));
	return $self->json->decode($res->content);
}

sub put {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = $self->ua->request(PUT($uri, Content_Type => 'application/json', Content => $self->json->encode($data)));
	return $self->json->decode($res->content);
}

sub delete {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = $self->ua->request(DELETE($uri, Content_Type => 'application/json', Content => $self->json->encode($data)));
	return $self->json->decode($res->content);
}

1;

=pod

=head1 NAME

Catalyst::Model::REST - REST model class for Catalyst

=head1 SYNOPSIS

    # model
    __PACKAGE__->config(
        uri => 'http://localhost:5984/',
    );

    # controller
    sub foo : Local {
        my ($self, $c) = @_;

        eval {
            my $doc = $c->model('MyData')->database('foo')->newDoc('bar')->retrieve;
            $c->stash->{thingie} = $doc->{dahut};
        };
        ...
    }


=head1 DESCRIPTION

This model class exposes L<REST::Client> as a Catalyst model.

=head1 CONFIGURATION

You can pass the same configuration fields as when you call L<REST::Client>.

=head1 METHODS

=head2 new

Called from Catalyst.

=head2 post

=head2 get

=head2 put

=head2 delete

=head1 AUTHOR

Kaare Rasmussen, <kaare @ cpan d.t com>

=head1 BUGS 

Please report any bugs or feature requests to bug-catalyst-model-rest at rt.cpan.org, or through the
web interface at http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Model-REST.

=head1 COPYRIGHT & LICENSE 

Copyright 2010 Kaare Rasmussen, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the same terms as 
Perl itself, either Perl version 5.8.8 or, at your option, any later version of Perl 5 you may 
have available.

=cut
