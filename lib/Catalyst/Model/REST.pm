package Catalyst::Model::REST;
use 5.010;
use Moose;
use Moose::Util::TypeConstraints;
use Try::Tiny;

extends 'Catalyst::Model';

use Carp qw(confess);
use Catalyst::Model::REST::Serializer;
use Catalyst::Model::REST::Response;
use LWP::UserAgent;
use HTTP::Request::Common qw/POST GET PUT DELETE/;

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
	$self->{ua} ||= LWP::UserAgent->new;
	return $self->{ua};
}

sub post {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = defined $data ? $self->_ua->request(POST($uri,
		Content_Type => $self->_serializer->content_type,
		Content => $self->_serializer->serialize($data)
	)) : $self->_ua->request(POST($uri));
	# Try to find a serializer for the result content
	my $content_type = $res->content_type;
	my $deserializer = $self->_serializer($content_type);
	my $content = $deserializer ? $deserializer->deserialize($res->content) : {};
	return Catalyst::Model::REST::Response->new(
		code => $res->code,
		response => $res,
		data => $content,
	);
}

sub get {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = defined $data ? $self->_ua->request(GET($uri,
		Content_Type => $self->_serializer->content_type,
		Content => $self->_serializer->serialize($data)
	)) : $self->_ua->request(GET($uri));
	# Try to find a serializer for the result content
	my $content_type = $res->content_type;
	my $deserializer = $self->_serializer($content_type);
	my $content = $deserializer ? $deserializer->deserialize($res->content) : {};
	return Catalyst::Model::REST::Response->new(
		code => $res->code,
		response => $res,
		data => $content,
	);
}

sub put {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = defined $data ? $self->_ua->request(PUT($uri,
		Content_Type => $self->_serializer->content_type,
		Content => $self->_serializer->serialize($data)
	)) : $self->_ua->request(PUT($uri));
	# Try to find a serializer for the result content
	my $content_type = $res->content_type;
	my $deserializer = $self->_serializer($content_type);
	my $content = $deserializer ? $deserializer->deserialize($res->content) : {};
	return Catalyst::Model::REST::Response->new(
		code => $res->code,
		response => $res,
		data => $content,
	);
}

sub delete {
	my ($self, $endpoint, $data) = @_;
	my $uri = $self->server.$endpoint;
	my $res = defined $data ? $self->_ua->request(DELETE($uri,
		Content_Type => $self->_serializer->content_type,
		Content => $self->_serializer->serialize($data)
	)) : $self->_ua->request(DELETE($uri));
	# Try to find a serializer for the result content
	my $content_type = $res->content_type;
	my $deserializer = $self->_serializer($content_type);
	my $content = $deserializer ? $deserializer->deserialize($res->content) : {};
	return Catalyst::Model::REST::Response->new(
		code => $res->code,
		response => $res,
		data => $content,
	);
}

__PACKAGE__->meta->make_immutable;

1;
__END__
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

=head2 post

=head2 get

=head2 put

=head2 delete

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
