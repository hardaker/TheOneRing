# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::GIT;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.1';

sub init {
    my ($self) = @_;
    $self->{'command'} = 'git';
    $self->{'mapping'} =
      {
       'status' =>
       {
	'args' => { },
       },

       # XXX: commit -a for commiting all files
       'commit' =>
       {
	'args' => { m => '-m' },
       },

#        'update' =>
#        {
# 	'args' => { r => '-r',
# 		    q => 'q',
# 		    N => 'N'},
#        },

       # need a special function for this to deal with how revs are handled
       # ie, -r foo file => foo file
       'diff' =>
       {
	'args' => { },
       },

       'annotate' =>
       {
	args => {  }
       },

#        'info' =>
#        {
# 	args => { r => '-r' }
#        },

       'add' =>
       {
	args => { #N => 'N',
		  #q => 'q'
		}
       },

       'remove' =>
       {
	command => 'rm',
	args => { #N => 'N',
		 q => 'q'
		}
       },

#        'list' =>
#        {
# 	args => { N => 'N',
# 		  q => 'q',
# 		  r => '-r'}
#        },

#        'export' =>
#        {
# 	args => { N => 'N',
# 		  q => 'q',
# 		  r => '-r'}
#        },

       'log' =>
       {
	args => { #q => 'q',
		  #r => '-r'
		}
       },

       'revert' =>
       {
	# XXX: requires file names to revert
	command => 'checkout',
	args => { # q => 'q',
		  # N
		},
       },

      };
}

1;
