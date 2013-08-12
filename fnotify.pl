# todo: grap topic changes

use strict;
use vars qw($VERSION %IRSSI);


use Irssi;
$VERSION = '0.0.3';
%IRSSI = (
    authors     => 'David Ron',
    contact     => 'dron@cj.com',
    name        => 'fnotify',
    description => 'Write a notification to a file that shows who is talking to you in which channel.',
    url         => 'https://github.com/cjdev/irssi-email-notifier',
    license     => 'GNU General Public License'
);

#--------------------------------------------------------------------
# Based on Thorsten Leemhuis's fnotify.pl
# http://blog.kintoandar.com/2011/06/irssi-irc-mention-notify-by-email-using.html
#
# In parts based on knotify.pl 0.1.1 by Hugo Haas
# http://larve.net/people/hugo/2005/01/knotify.pl
# which is based on osd.pl 0.3.3 by Jeroen Coekaerts, Koenraad Heijlen
# http://www.irssi.org/scripts/scripts/osd.pl
#
# Other parts based on notify.pl from Luke Macken
# http://fedora.feedjack.org/user/918/
#
# David Ron added support for mail and removed the race condition.
#
#--------------------------------------------------------------------

# Please set the variable (don't forget to escape "\" the "@" symbol like the example)
my $EMAIL = "YOUR_ADDRESS\@gmail.com";

#--------------------------------------------------------------------
# Private message parsing
#--------------------------------------------------------------------

sub priv_msg {
    my ($server,$msg,$nick,$address,$target) = @_;
    filewrite($nick." " .$msg );
}

#--------------------------------------------------------------------
# Printing hilight's
#--------------------------------------------------------------------

sub hilight {
    my ($dest, $text, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
    filewrite($dest->{target}. " " .$stripped );
    }
}

#--------------------------------------------------------------------
# The actual printing
#--------------------------------------------------------------------

sub filewrite {
    my ($text) = @_;
    # FIXME: there is probably a better way to get the irssi-dir...
	my $date = `date`;
	my $random = my $random_number = int(rand(10000));
	my $fileName = "$ENV{HOME}/.irssi/notifications/fnotify$random";
    open(FILE,">>$fileName");
    print FILE $date . $text . "\n\n";
    close (FILE);
	my $mail=`cat $fileName | mail -s "IRSSI Notification" $EMAIL`;
}

#--------------------------------------------------------------------
# Irssi::signal_add_last / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight"); 

