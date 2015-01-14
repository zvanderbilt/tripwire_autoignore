#!/usr/bin/perl

#Path to tripwire policy backup file
$policy_file = "/etc/tripwire/twpol.txt.BKP";

#Put tripwire policy file into an array
@CONTENT = `cat $policy_file`;

#False Positive Entries we want to ignore
@IGNORE_LIST = `awk '{print \$2}' ./test_results`;

#Open a new file called twpol.txt
open(NEWFILE,">/etc/tripwire/twpol.txt");

#Go through each line in the twpol.txt.BKP file
foreach my $line (@CONTENT)
{
    	#Chop off the hard return at the end of each line
    	chomp($line);

    	#Reset IGNORE_FLAG before each check
    	my $IGNORE_FLAG = "F";

    	#Then check the line against the ignore list
    	foreach my $entry (@IGNORE_LIST)
    	{
            	#Chop off the hard return at the end of each line
            	chomp($entry);

            	#Compare tripwire line against each ignore list line
            	if(($line =~ m/\s$entry\s/)&&($line =~ m/-\> \$/))
            	{
                    	#Setting the FLAG to true means a match was found
                    	$IGNORE_FLAG = "T";

                    	print "[Ignoring]: $line\n";
            	}
    	}

    	if($IGNORE_FLAG eq "F")
    	{
            	#Write policy entry to file, if not found in the ignore list
            	print NEWFILE "$line\n";
    	}
}
close(NEWFILE);
