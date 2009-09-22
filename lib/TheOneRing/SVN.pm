# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::SVN;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub update {
    my $self = shift;
    system("svn", "update", @_);
}

# XXX: -q
sub status {
    my $self = shift;
    system("svn", "status", @_);
}

# XXX: -m
sub commit {
    my $self = shift;
    system("svn", "commit", @_);
}

# XXX: -m
sub diff {
    my $self = shift;
    system("svn", "diff", @_);
}

1;
