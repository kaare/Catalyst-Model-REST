package Catalyst::Model::REST;
use 5.010;
use Moose;
use Moose::Util::TypeConstraints;
use Try::Tiny;
use HTTP::Tiny;

extends 'Catalyst::Model';

use Carp qw(confess);
use Catalyst::Model::REST::Serializer;
use Catalyst::Model::REST::Response;

has 'server' => (
    isa => 'Str',
    is  => 'rw',
	lazy    => 1,
	builder => '_build_server',
);
has 'type' => (
    isa => enum ([qw{application/json application/xml application/yaml}]),
    is  => 'rw',
	default => 'json',
);

no Moose::Util::TypeConstraints;

sub _build_server {
	my ($self) = @_;
	$self->{server} ||= $self->config->{server} if $self->config->{server};
}

sub _serializer {
	my ($self, $type) = @_;
	$type ||= $self->type;
	try {
		$self->{serializer}{$type} ||= Catalyst::Model::REST::Serializer->new(type => $type);
	} catch {
		# Spell it out
		undef $self->{serializer}{$type};
	};
	return $self->{serializer}{$type};
}

sub _ua {
	my ($self) = @_;
	$self->{ua} ||= HTTP::Tiny->new;
	return $self->{ua};
}

sub _call {
	my ($self, $method, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = defined $data ? $self->_ua->request($method, $uri, {
		headers => { 'content-type' => $self->_serializer->content_type },
		content => $self->_serializer->serialize($data)
	}) : $self->_ua->request($method, $uri);
	return { code =>  $res->{status}, error => $res->{reason}} unless $res->{success};

	# Try to find a serializer for the result content
	my $content_type = $res->{headers}{content_type};
	my $deserializer = $self->_serializer($content_type);
	my $content = $deserializer ? $deserializer->deserialize($res->{content}) : {};
	return Catalyst::Model::REST::Response->new(
		code => $res->{status},
		response => $res,
		data => $content,
	);
}

sub get {
	my $self = shift;
	return $self->_call('GET', @_);
}

sub post {
	my $self = shift;
	return $self->_call('POST', @_);
}

sub put {
	my $self = shift;
	return $self->_call('PUT', @_);
}

sub delete {
	my $self = shift;
	return $self->_call('DELETE', @_);
}

sub options {
	my $self = shift;
	return $self->_call('OPTIONS', @_);
}

__PACKAGE__->meta->make_immutable;

1;
__END__
# ABSTRACT: REST model class for Catalyst
=pod

=head1 NAME

Catalyst::Model::REST - REST model class for Catalyst

=head1 SYNOPSIS

	# model
	__PACKAGE__->config(
		server => 'http://localhost:3000',
		type   => 'application/json',
	);

	# controller
	sub foo : Local {
		my ($self, $c) = @_;
		my $res = $c->model('MyData')->post('foo/bar/baz', {foo => 'bar'});
		my $code = $res->code;
		my $data = $res->data;
		...
	}


=head1 DESCRIPTION

This model class makes REST connectivety easy.

=head1 METHODS

=head2 new

Called from Catalyst.

=head2 method methods

Catalyst::Model::REST accepts the standard HTTP 1.1 methods

	post
	get
	put
	delete
	options

All methods take these parameters

	url - The REST service
	data - The data structure (hashref, arrayref) to send

=head1 AUTHOR

Kaare Rasmussen, <kaare at cpan dot com>

=head1 BUGS 

Please report any bugs or feature requests to bug-catalyst-model-rest at rt.cpan.org, or through the
web interface at http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Model-REST.

=head1 COPYRIGHT & LICENSE 

Copyright 2010 Kaare Rasmussen, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the same terms as 
Perl itself, either Perl version 5.8.8 or, at your option, any later version of Perl 5 you may 
have available.
