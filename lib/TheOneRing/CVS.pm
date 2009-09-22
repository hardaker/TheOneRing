# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::CVS;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub update {
    my $self = shift;
    system("cvs", "update", @_);
}

# XXX: some magic with update?
# sub status {
#     my $self = shift;
#     system("cvs", "status", @_);
# }

# XXX: -m
sub commit {
    my $self = shift;
    system("cvs", "commit", @_);
}

1;
