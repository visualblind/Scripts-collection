#!/usr/bin/perl -w         		# print warnings
use Net::SCP qw (scp);

# init
$|++;                      		# force auto flush of output buffer
my $VERSION = "0.01b";
my $dir = "/tmp";			# see DNSEXPORTPATH
my ($file, $source, $destination);
my @destinations;
my $xsltproc = "/usr/bin/xsltproc";	# apt-get install xsltproc libnet-scp-perl

# as we use bind9 only
$xsl{zone} = "/var/www/ipplan/contrib/bind9_zone.xsl";
$xsl{revzone} = "/var/www/ipplan/contrib/bind9_revzone.xsl";

# main
opendir (BIN, $dir) or die "Can't open $dir: $!";

# parse xml files
while (defined ($file = readdir BIN)) {
  if (-T "$dir/$file" && $file =~ /^(zone|revzone)/) {
    open (FH, "< $dir/$file")
        or die "Couldn't open $dir/$file for reading: $!\n";

# get dns servers
    @destinations = ();    
    while (<FH>) {
      push (@destinations, $last) if (($_ =~ /(^<\/primary>|^<\/secondary>)/) && (length($last)>1));
      $last = $_;
    } # while FH
    close (FH);

# select template
    $file =~ /(\w*)_/;
    my $template = $xsl{$1};

# generate zone files from xml
    open (STDOUT, ">$dir/db.$file");	# ugly, but does its job as -o for xsltproc is not working
    @args = ("$xsltproc", "$template", "$dir/$file");
    system (@args) == 0 
      or die "system @args failed: $?";	
    print "\n";				# just to please bind9
#    close (STDOUT);			# is there a better solution?

# scp files generated
# remember to copy pub-key in advance
    foreach $destination (@destinations) {
      $source = "$dir/db.$file";
      $scp = new Net::SCP;
      $scp->scp ($source, $destination) or die $scp->{errstr};
      unlink ($source) or die "Couldn't unlink $source: $!";
      unlink ("$dir/$file") or die "Couldn't unlink $dir/$file: $!";
    } # foreach          
  } # if zone || revzone
} # while files

closedir (BIN);

