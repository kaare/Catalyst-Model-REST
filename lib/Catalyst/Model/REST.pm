package Catalyst::Model::REST;
use base qw/Catalyst::Model/;
use strict;
use warnings;

use NEXT;
use Carp qw(confess);
use JSON::XS;
use HTTP::Request::Common qw/POST GET PUT DELETE/;

our $VERSION = '0.01';

sub new {
    my ($class, $c, $config) = @_;
    my $self = $class->NEXT::new($c, $config);
    $self->config($config);
    my $conf = $self->config;
    $self->{json} = JSON->new->utf8;
    $c->log->debug("REST instantiated") if $c->debug;
    return $self;
}

sub post {
	my ($self, $uri, $data);
	my $res = request(POST($uri, Content_Type => 'application/json', Content => $self->{json}->encode($data)));
	return $self->{json}->decode($res->content);
}

sub get {
	my ($self, $uri, $data);
	my $res = request(GET($uri, Content_Type => 'application/json', Content => $self->{json}->encode($data)));
	return $self->{json}->decode($res->content);
}

sub put {
	my ($self, $uri, $data);
	my $res = request(PUT($uri, Content_Type => 'application/json', Content => $self->{json}->encode($data)));
	return $self->{json}->decode($res->content);
}

sub delete {
	my ($self, $uri, $data);
	my $res = request(DELETE($uri, Content_Type => 'application/json', Content => $self->{json}->encode($data)));
	return $self->{json}->decode($res->content);
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
