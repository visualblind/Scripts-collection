#!/usr/local/bin/perl

# This script is designed to page in used swap on any device that has swap in use on 
# a FreeNAS system. You would want to run this periodically to help ensure that swap 
# is not on use on a device which may fail at any time, for example, a drive in a raid set
#
# It accomplishes this by swapoff/swapon a given device rather than swapoff all devices,
# the idea being that if swap was actually necessary, then the system will always have access
# to swap is swap is never fully disabled.
#
# This is in response to an issue that became apparent on FreeNAS 9.10
# 	https://forums.freenas.org/index.php?threads/swap-with-9-10.42749/
#
# The script does nothing if there is no swap in use.
#
# To use, simply run via cron. Or directly when needed.
#
# If debug = 1, and you untick "Redirect Output" in FreeNAS Add Cron Job, 
# you'll get an email only when swap was paged in.
#
# This script lives at: 
# https://forums.freenas.org/index.php?threads/script-to-pagein-any-used-swap-to-prevent-kernel-crashes.46206/
#
# stux


# VERSION HISTORY
#####################
# 2016-09-21 	Initial Version
# 2016-09-21 	Tightenned swapinfo grep to only use /dev/*.eli devices. This prevents a potential
#		issue after hot swapping devices.
# 2017-02-02	Fixed cosmetic issue. Bytes -> KiBs

###############################################################################################
## CONFIGURATION
################

## DEBUG LEVEL
## 0 means no output. 1,2,3,4 provide more verbosity
## 1 output only if paging in. If run from cron, this means you'll only get an email if
##   swap was in use.
## 2 output startup message and at least nothing done message
## 3 more.
## 4 etc.
$debug = 1;

## PAGEIN ALL
## A debug option which is used to verify functionality even if there is no swap in use
## 0 means only pagein active swap devices. You should use 0.
## 1 means pagein all devices.
$pagein_all = 0;


#modify nothing below here
###############################################################
use POSIX qw(strftime);

dprint( 1, "Paging in swap...\n" );

pagein_swap_devices( get_swap_devices());



######### SUBS

# returns a nested list of active swap devices. Each item in the list is an array, 
# [0] is the device
# [1] is the bytes used
sub get_swap_devices
{
	my $swapinfo_output = `swapinfo | grep "/dev/.*\.eli"`;
	chomp $swapinfo_output;
	dprint(1,"swapinfo:\n$swapinfo_output\n");
	
	my @swap_lines = split("\n", $swapinfo_output );
	dprint_list(3,"swap_lines", @swap_lines);	
	

	my @swap_devs = ();
	foreach my $line (@swap_lines)
	{
		dprint(3,"$line\n");
		
		my @vals = split(" ", $line);
		
		# [0] = device
		# [1] = 1K-blocks
		# [2] = Used
		# [3] = Avail
		# [4] = Capacity

		if( $vals[2] > 0 || $pagein_all )
		{
			dprint(2, "Adding $vals[0] with $vals[2]KiB of swap to page in list.\n" );
			push @swap_devs, [$vals[0],$vals[2]];
		}		
	}

	return @swap_devs;
}

#pages in a device
sub pagein_swap_device
{
	my ($device,$used) = @_;

	dprint(0,"Paging in $used KiBs on $device\n");
	
	`swapoff $device`;
	`swapon $device`;

	return;
}

sub pagein_swap_devices
{
 	my @devs = @_;

	if( @devs > 0 )
	{
		foreach my $devinfo (@devs)
		{
			my $dev = $devinfo->[0]; 
			my $used = $devinfo->[1];
				
			#dprint(0, "dev: $dev used: $used\n");
			pagein_swap_device($dev,$used);
		}
	}
	else
	{
		dprint(1,"No swap was paged in as no swap was used on any device\n");
	}

	return;
}


sub build_date_string
{
	my $datestring = strftime "%F %H:%M:%S", localtime;
	
	return $datestring;
}

sub dprint_list
{
	my ( $level,$name,@output) = @_;
		
	if( $debug > $level ) 
	{
		dprint($level,"$name:\n");

		foreach my $item (@output)
		{
			dprint( $level, " $item\n");
		}
	}

	return;
}

sub dprint
{
	my ( $level,$output) = @_;
	
#	print( "dprintf: debug = $debug, level = $level, output = \"$output\"\n" );
	
	if( $debug > $level ) 
	{
		my $datestring = build_date_string();
		print "$datestring: $output";
	}

	return;
}
