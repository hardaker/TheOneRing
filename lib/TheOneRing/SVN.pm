# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::SVN;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub init {
    my ($self) = @_;
    $self->{'command'} = 'svk';
    $self->{'mapping'} =
      {
       'status' =>
       {
	'args' => { q => 'q' },
       },

       'commit' =>
       {
	'args' => { m => '-m',
		    q => 'q',
		    N => 'N'},
       },

       'update' =>
       {
	'args' => { r => '-r',
		    q => 'q',
		    N => 'N'},
       },

       'diff' =>
       {
	'args' => { r => '-r',
		    N => 'N'},
       },

      };
}

1;
