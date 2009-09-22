# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::SVK;

use strict;
use TheOneRing::SVN;

# we're functionally really really close to SVN, so we'll inherit a
# lot of that for option mapping, etc and augment as needed.
our @ISA = qw(TheOneRing::SVN);

our $VERSION = '0.1';

sub init {
    my ($self) = @_;
    $self->SUPER::init(@_);

    $self->{'command'} = 'svk';

    # now just modify our slight differences to things...
    # XXX: nothing yet

    # eg:
    # $self->{'mapping'}{'status'}{'args'}{'q'} = "Q";
}

1;
