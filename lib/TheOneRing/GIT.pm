# Copyright (C) 2009-2012 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::GIT;

use strict;
use TheOneRing;

our @ISA = qw(TheOneRing);

our $VERSION = '0.3';

sub init {
    my ($self) = @_;
    $self->{'command'} = 'git';
    $self->{'mapping'} =
      {
#        'status' =>
#        {
# 	'args' => { },
#        },

       # XXX: commit -a for commiting all files
       'commit' =>
       {
	options => sub { my ($self, @args) = @_;
			 return ['-a'] if ($#args == -1);
			 return [] },
	'args' => { m => '-m' },
       },

        'update' =>
        {
	 'command' => 'pull',
	 'options' => ['origin', 'HEAD'],
 	'args' => {
#		    r => '-r',
# 		    q => 'q',
# 		    N => 'N',
		  },
	},

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

       'move' =>
       {
	command => 'mv',
	args => { #n => 'n'
		},
       },

      };
}

sub ignore {
    my ($self, @args) = @_;
    $self->add_to_file(".gitignore", @args);
}

sub status {
    my ($self, @args) = @_;
    # lame quick processing
    my $quiet = 0;
    while ($args[0] eq '-q') {
	$quiet = 1;
	shift @args;
    }

    open(GITCMD, "git status " . join(" ", @args) . "|");
    while (<GITCMD>) {
	last if ($quiet && /# Untracked files:/);
	print;
    }
}

1;
