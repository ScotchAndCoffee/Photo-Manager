#!/usr/bin/perl -w
use strict;

print "Searching for RAW files without matching JPG preview...\n";

my @jpgs = glob("*.jpg *.JPG");
@jpgs or die "There are now preview JPGs in this directory.";

my @raws = glob("NEF/*.NEF RAW/*.NEF");
@raws or die "There are no RAWs we could purge.";


foreach (@jpgs) {
   $_ =~ s/\..*//;
} 

my @toDelete;
my $raw;
foreach (@raws) {
   $raw = $_;
   $_ =~ s/\..*//;
   $_ =~ s/^.*\///;
   if(!($_ ~~ @jpgs)){
		push(@toDelete, $raw);
   }
} 

if(@toDelete){
	print "Looks like we should delte the following RAW files:\n";
	foreach(@toDelete){print $_ . "\n";}
	
	print "Proceed with deleting? (Y/N): ";
	my $answer = <STDIN>;
	chomp($answer);
	
	if($answer eq "Y"){
		print "Deleting...";
		foreach my $file ( @toDelete ) {
         	unlink $file or warn "Could not delete $file: $!";
     	}
	}
	elsif($answer eq "N"){
		print "Aborting without deleting anything.";
	}
	else{
		print "Wrong input - aborting without deleting anything.";
	}
}
else{
	print "Did not find any RAW files eligible to be deleted."
}



