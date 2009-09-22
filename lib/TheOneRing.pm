# Copyright (C) 2009 Wes Hardaker
# License: GNU GPLv2.  See the COPYING file for details.
package TheOneRing;

use strict;
use UNIVERSAL;
use Getopt::GUI::Long;

our $VERSION = '0.1';

our %master_arguments =
  (
   'commit' =>
   [
   ["m|message|msg=s" => "Commit message"],
   ],

   'diff' =>
   [
   ["r|revision|msg=i" => "Revision to diff against"],
   ],

   'test' =>
   [
   ["f|foo" => "bar"],
   ],
  );



# note: this new clause is used by most sub-modules too, altering it
# will alter them.
sub new {
    my $type = shift;
    my ($class) = ref($type) || $type;
    my $self = {};
    $self->{'options'} = {@_};
    bless($self, $class);
    $self->init();
    return $self;
}

# prototype for children to optionally override
sub init {
}

# the meat of the work
sub dispatch {
    my ($self, $command, @args) = @_;

    my $repotype;

    # do checkout/stuff first
    if ($command eq 'checkout' || $command eq 'co' ||
	$command eq 'export') {
	# XXX
	return 1;
    }

    #
    # we could do a bunch of autoloading tricks to have each module
    # self-identify, but that would be a lot slower.  By only loading
    # the module we need and hard coding this determination list it
    # should make the one ring a bit faster to run.
    #

    # determine based on what's in the directory
    if (-d '.svn') {
	# that's an easy check.
	$repotype = 'SVN';
    } elsif (-d 'CVS') {
	# that's an easy check.
	$repotype = 'CVS';
    } elsif (-d '.git') {
	# that's an easy check.
	$repotype = 'GIT';
    } else {
	$repotype = $self->find_cached_type();
	if (!defined($repotype)) {
	    # XXX: try dynamic system of some kind here now that the speed
	    # attempt is done?
	    print STDERR
	      "Failed to determine the type of repository we're in.\n";
	    exit 1;
	}
    }
    $self->debug("found subtype $repotype");

    my $submodule = $self->load_subtype($repotype);
    $self->debug("running $repotype->$command");

    # they have a method defined
    if ($submodule->can($command)) {
	$submodule->$command(@args);
	return 1;
    }

    # see if they have a defined command mapping
    if (exists($submodule->{'mapping'}{$command})) {
	# process and run it
	@args = $submodule->map_and_run($command,
					$submodule->{'mapping'}{$command},
					@args);
	$submodule->System(@args);
	return 1;
    }

    print STDERR "ERROR: The \"$repotype\" module does know the command \"$command\"\n";
    exit 1;
}

sub map_and_run {
    my ($self, $subcmd, $map, @args) = @_;
    my %opts = @{$self->{'defaults'}{$subcmd} || []};

    # first process against the known arguments
    my $cmdoptions = $master_arguments{$subcmd};

    # though it's discouraged to add more on a per-submodule, we do support it.
    push @$cmdoptions, @{$self->{'master_arguments'}}
      if (exists($self->{'master_arguments'}));

    Getopt::GUI::Long::Configure(qw(display_help no_ignore_case no_gui
				    require_order));
    GetOptions(\%opts, @$cmdoptions) || exit;

    # process %opts

    my $newcommand = $self->{'command'} || $subcmd;
    my $newsubcmd  = $map->{'command'} || $subcmd;
    print "here: $newcommand, $newsubcmd\n";
    $self->System($newcommand, $newsubcmd);
}


sub load_subtype {
    my ($self, $type) = @_;

    # try and load it
    my $havesubmod = eval "require TheOneRing::$type;";
    return if (!$havesubmod);

    # once loaded, create an instance
    my $submod = eval "new TheOneRing::$type();";

    # copy in our running options
    $submod->{'options'} = $self->{'options'};

    return $submod;
}

sub get_cwd {
    require Cwd;
    return Cwd::getcwd();
}

sub get_config_dir {
    my ($self) = @_;

    my $ordir = $self->{'configdir'} || $ENV{'HOME'} . "/.theonering/";
    if (! -d $ordir) {
	mkdir($ordir);
    }
    return $ordir;
}

sub get_config_file {
    my ($self, $filename) = @_;

    my $dir = $self->get_config_dir();
    return "$dir/$filename";
}

sub find_cached_type {
    my ($self, $cwd) = @_;

    $cwd ||= $self->get_cwd();

    # check the current cache if possible
    my $type = $self->check_known_types($cwd);
    return $type if (defined($type));

    # ok, failing that lets try and create a fresh list.
    $self->debug("building a fresh list\n");
    $self->build_known_types();

    # Then try again now that we have a fresh list
    return $self->check_known_types($cwd);
}

sub check_known_types {
    my ($self, $cwd) = @_;

    $cwd ||= $self->get_cwd();

    my $typecache = $self->get_config_file('typecache');

    if (-f $typecache) {
	open(DIRTYPES, $typecache);
	while (<DIRTYPES>) {
	    chomp();
	    my ($dir, $type) = split;
	    if ($dir eq $cwd) {
		close(DIRTYPES);
		return $type;
	    }
	}
	close(DIRTYPES);
    }
    return; # fail!
}

sub build_known_types {
    my ($self) = @_;
    # do some things to build the 

    my $typecache = $self->get_config_file('typecache');

    my $dir = $self->get_config_dir;
    open(DIRTYPES,">$typecache");

    # svk map the existing checkout list
    open(SVKLIST, "svk co --list|");
    while (<SVKLIST>) {
	last if (/==========/);
    }
    while (<SVKLIST>) {
	my @stuff = split();
	printf DIRTYPES "%-60s SVK\n",$stuff[$#stuff];
    }
    close(SVKLIST);

    close(DIRTYPES);
}

sub debug {
    my $self = shift;
    if ($self->{'options'}{'debug'}) {
	print STDERR (join(" ",@_), "\n");
    }
}

sub System {
    my $self = shift;
    if ($self->{'options'}{'dryrun'}) {
	print STDERR "would run: ", @_, "\n";
    } else {
	$self->debug("running: ", @_);
	system(@_);
    }
}

#
# Aliases to other functions
#
sub co {
    my $mod = shift;
    $mod->checkout(@_);
}

#
# XXX common argument processing needed
#  ideas: * have each submodule publish a hash ref of things it can accept
#           plus a mapping table of one ring arguments to sub-command args
#         * fail on unknown arg based on list
#         * --something for forced arg passing
#

#
# XXX: create an AUTOLOAD subroutine to throw an error when someone
# tries to run a command on a mode that doesn't exist.
#

1;
