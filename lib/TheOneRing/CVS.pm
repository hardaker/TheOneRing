# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing::CVS;

use strict;
use TheOneRing;
use IO::File;

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

       'annotate' =>
       {
	args => { r => '-r',
		  'N' => 'l'}
       },

       'export' =>
       {
	args => { N => 'l',
		  r => '-r'}
       },

       'log' =>
       {
	args => { N => 'l',
		  r => '-r'}
       },

      };
}

sub info {
    my $fh = IO::File->new("<CVS/Repository");
    my $repo = <$fh>;
    $fh->close;

    $fh = IO::File->new("<CVS/Root");
    my $root = <$fh>;
    $fh->close;

    print "Root:       $root";
    print "Repository: $repo";
    chomp($root);
    print "Full Path:  $root/$repo";
}

1;
