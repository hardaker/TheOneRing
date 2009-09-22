# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::SVK;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub init {
    my ($self) = @_;
    $self->{'command'} = 'svk';
    $self->{'mapping'} =
      {
       'test' =>
       {
	'args' => { m => 'mapped' },
       },

       'status' =>
       {
	'args' => { q => 'q' },
       },

       'commit' =>
       {
	'args' => { m => 'm' },
       },

      };
}

sub update {
    my $self = shift;
    system("svk", "update", @_);
}

# XXX: -m
sub commit {
    my $self = shift;
    system("svk", "commit", @_);
}

# 
sub diff {
    my $self = shift;
    system("svk", "diff", @_);
}

1;
