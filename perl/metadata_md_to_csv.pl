#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long;

my $usage = <<EOS;
  Synopsis: metadata_md_to_csv.pl [options] FILENAME.md
  
  For markdown-format metadata used in the Legume Federation data store, circa Jan 2017, 
  parse and generate two tables:
  one with attribute-value format, for a data set as a whole
  one with attribute-value-unit format, for files within the data set
  
  Output in tabular format to stdout, or in either tabular or CSV format to a specified
  output file.
  
  OPTIONS:
    -outbasefile  Specify FILENAME; otherwise, default to stdout.
    -format       Specify "csv" or "tab". Default tab.
    -help         This message. 
EOS

my $help;
my $format = "tab";
my $outbasefile = "stdout";

GetOptions (
  "outbasefile:s" =>  \$outbasefile,
  "format:s" =>       \$format,
  "help" =>           \$help,
);

die "\n$usage\n" if ( $help or not $ARGV[0] );
die "\n$usage\n\nNOTE: Format must be tab or csv (default is tab)\n\n" if ( $format !~ /csv|tab/i );

my $file_in = $ARGV[0];

my (%dataset_H, %file_HoH);
my (@dataset_A, @fileset_A);
my ($attr, $key, $val);
my $ct_dataset_attr=0;
my $ct_fileset_attr=0;

open (my $IN_FH, "<", $file_in) or die "can't open in $file_in: $!\n";

# Open filehandles - depending on the output format and whether "stdout" was indicated.
my ($OUT_CSV_DATA_FH, $OUT_CSV_FILES_FH, $OUT_TAB_DATA_FH, $OUT_TAB_FILES_FH);
if ( $outbasefile !~ /stdout/i ) {
  if ($format =~ /csv/i) {
    open ($OUT_CSV_DATA_FH,  ">", "$outbasefile.dataset.csv") or die "can't open out $outbasefile.csv: $!\n";
    open ($OUT_CSV_FILES_FH, ">", "$outbasefile.fileset.csv") or die "can't open out $outbasefile.files.csv: $!\n";
  }
  elsif ($format =~ /tab/i) {
    open ($OUT_TAB_DATA_FH,  ">", "$outbasefile.dataset.tab") or die "can't open out $outbasefile.tab: $!\n";
    open ($OUT_TAB_FILES_FH, ">", "$outbasefile.fileset.tab") or die "can't open out $outbasefile.files.tab: $!\n";
  }
  else { die "unrecognized output format: $format; expected: tab or csv\n" }
}

# Read input and store attributes and values in hashes.
# Also store attributes in an array, to preserve attribute order.
# Printing will happen at the end.
while (<$IN_FH>){
  chomp; 
  my $line = $_;

  # Attribute line
  if ($line =~ /^#+ *(\w.+\w) *$/){
  
    # convert e.g. "Publication DOI" to publication_doi
    $attr = lc($1); $attr =~ s/ /_/g; 
    
    if ($attr =~ /^file_/i) { # one of the "File" attributes
      $file_HoH{$attr} = ""; # initialize this hash element; we'll fill it later.
      $fileset_A[$ct_fileset_attr] = $attr;
      $ct_fileset_attr++;
    }
    else { # A dataset attribute rather than a "File" attributes
      $dataset_H{$attr} = ""; # initialize this hash element; we'll fill it later.
      $dataset_A[$ct_dataset_attr] = $attr;
      $ct_dataset_attr++;
    }
  } 
  
  # Value line (for "regular" not "File" attributes)
  if ($line =~ /^(\w.+\S)\s*$/){ 
    $val = $1;
    if (length($dataset_H{$attr}) == 0) { # First (perhaps only?) line for this value
      $dataset_H{$attr} = "$val"; # Initiate the string
    }
    else { # The string is started, so add a space:
      $dataset_H{$attr} .= " $val"; # Add to the string, separated by a space
    }
  } 
  
  # Key/value/attribute for file lists
  if (/^  ([^#]\S+)\s+(\S.+\S)\s*$/){ 
    my $key = $1;
    my $val = $2;
    #print "{$attr}\t[$key]\t($val)\n";
    if (!$file_HoH{$attr}) {
      $file_HoH{$attr} = {$key=>$val};
    }
    else {
      $file_HoH{$attr}{$key} = $val;
    }
  }
}

# Dump dataset attribute-value pairs. 
# For tabular output, just print.
# For CSV, first build up two CSV strings: attributes and values.
my $attr_csv_string;
my $val_csv_string;
foreach $attr (@dataset_A) {
  my $value = $dataset_H{$attr};
  if ($value =~ /(.+,.+)/) {$value = "\x27$1\x27"};

  if ( $format =~ /csv/i ) {
    $attr_csv_string .= "$attr,";
    $val_csv_string .= "$value,";
  }
  elsif ( $format =~ /tab/i ) {
    if ( $outbasefile =~ /stdout/i ) {
      print "$attr\t$value\n";
    }
    else {
      print $OUT_TAB_DATA_FH "$attr\t$value\n";
    }
  }
}

# Print CSV strings (for dataset attribute-value pairs)
if ($format =~ /csv/i) {
  $attr_csv_string =~ s/,$//; # remove trailing comma
  $val_csv_string =~ s/,$//; # remove trailing comma
  
  if ( $outbasefile =~ /stdout/i ) {
    print $attr_csv_string, "\n";
    print $val_csv_string, "\n";
  }
  else {
    print $OUT_CSV_DATA_FH $attr_csv_string, "\n";
    print $OUT_CSV_DATA_FH $val_csv_string, "\n";
  }
}

# Print HEADER for CSV strings (for fileset attribute-value-unit triplets)
if ( $format =~ /csv/i ) { # print header
  if ( $outbasefile =~ /stdout/i ) {
    print "filename,attribute,value\n";
  }
  elsif ( $format =~ /csv/i ) {
    print $OUT_CSV_FILES_FH "filename,attribute,value\n";
  }
  elsif ( $format =~ /tab/i ) {
    # do nothing, because we don't need the header for tab files
  }
}

# Print CSV results  (for fileset attribute-value-unit triplets)
foreach $attr (@fileset_A) {
  while ( ($key, $val) = each %{ $file_HoH{$attr}} ) {
    if ( $outbasefile =~ /stdout/i ) {
      if ($format =~ /tab/i ) {
        print "$key\t$attr\t$val\n";
      }
      elsif ( $format =~ /csv/i ) { 
        print "$key,$attr,$val\n";
      }
    }
    else {
      if ( $format =~ /tab/i ) {
        print $OUT_TAB_FILES_FH "$key\t$attr\t$val\n";
      }
      elsif ( $format =~ /csv/i ) {
        print $OUT_CSV_FILES_FH "$key,$attr,$val\n";
      }
    }
  }
}

__END__

Versions
2016 ...
v01 sc 12-20 Started. Reports tabular or CSV output for dataset A-V pairs and fileset A-V-U triplets
v02 sc 12-20 Add some documentation.


