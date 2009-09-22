# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::CVS;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub init {
    my ($self) = @_;
    $self->{'command'} = 'cvs';
    $self->{'mapping'} =
      {
# might be able to hack this through update
#        'status' =>
#        {
# 	'args' => { q => 'q' },
#        },

       'commit' =>
       {
	'args' => { m => '-m',
		    N => 'l'},
       },

       'update' =>
       {
	# need -D flag equiv
	'args' => { r => '-r',
		    N => 'l'},
       },

       'diff' =>
       {
	'args' => { r => '-r',
		    N => 'l'},
       },

      };
}

1;
