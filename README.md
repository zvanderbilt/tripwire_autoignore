# tripwire_autoignore
Automatically ignores irrelevant files and filesystems


Tripwire How to

Install
#yum/apt-get install tripwire

Create keys, if not prompted during installation, ie, fedora repo, debian, etc. 
#sudo tripwire-setup-keyfiles

Configure default profile
#sudo twadmin --create-polfile /etc/tripwire/twpol.txt
Initialize the tripwire database
#sudo tripwire --init

Save test results to file to consult during policy customization
#sudo tripwire --check | grep Filename > test_results
Open test_results. You’ll notice there are ~100 errors regarding files/directories that cannot be found. Go through the errors and locate the corresponding references in the  /etc/tripwire/twpol.txt. Comment out all the files causing errors. For example, on ubuntu systems, /etc/rc.boot does not exist as a boot script so it should be commented out.  

(
  rulename = "Boot Scripts",
  severity = $(SIG_HI)
)
{
        /etc/init.d             -> $(SEC_BIN) ;
        #/etc/rc.boot            -> $(SEC_BIN) ;
        /etc/rcS.d              -> $(SEC_BIN) ;

*** To automate this various tedious process detailed above, save this script to /etc/tripwire/configure.pl


Secure it
#chmod 700 /etc/tripwire/configure.pl
#chown root:root /etc/tripwire/configure.pl

Backup twpol.txt
#cp twpol.txt twpol.txt.BKP

Run it
./configure.pl

Once configured, you need to implement it by recreating the encrypted policy .cfg.
#sudo twadmin -m P /etc/tripwire/twpol.txt
Reinitialize the database
#sudo tripwire --init
Create a file on /root/
#sudo touch /root/test.file

Verify no more errors are present
# root should be the only file flagged as being modified/created.

Delete your test file
#rm /root/test.file

Run tripwire in interactive mode
#tripwire --check --interactive

****This brings up the report file in the default text editor. Remove any [X] next to files that were modified to not update the database with their new values. That will result in the file being flagged again during the next check. If all changes were intended write quit out of your text editor. Being in interactive mode, once you save the file, it is written to the database with the new values. No need to reinitialize hence forth.
