###############################################################
#
#   Synaccess Networks, Inc.  (www.synaccess-net.com)
#   Sept. 6th, 2005
#   Perl Script Example 1
#   for NP series.
#
################################################################

# Intialize some variables
# System IP address
use IO::Socket;
#filling Synaccess system IP address and  port number below

$sock = new IO::Socket::INET (PeerAddr => '192.168.10.21',
                              PeerPort => 23,
                              Proto    => 'tcp');

die "\n Can't create socket! $!" unless $sock;

#Local msg
print "\nSocket open OK\n\n";

#optional - capture incoming msg. The msg contains some garbled characters characters used for Telnet Mode setting. Ignor it.
$sock->recv($myCap, 1024);
#print $myCap;

#---------important-----------
#Must send as startup
# $msgSend = "\r";
# $sock->send($msgSend);
#---------important-------------


#---------important-----------
# a command string is ended with "\r"
#Unix - "\r",  DOS - "\n\r"
#---------important-------------


#---------Login/ID/Password-------------
# sleep(1);
#send login command
# $tMsg = "now sending login cmd\r\n";
# print $tMsg;

# $msgSend = "login\r";
# $sock->send($msgSend);
# sleep(1);
# $sock->recv($myCap, 1024);
# $tMsg = "cap'd msg after login cmd\r\n";
# print $myCap;


#send user ID
# $tMsg = "now sending user ID-outlet4\r\n";
# print $tMsg;
$msgSend = "admin\r";
$sock->send($msgSend);
#Optinal - to capture and see what's going on
# $sock->recv($myCap, 1024);
# print $myCap;

sleep 1;  #may require delay. Min. 100ms.  Here the delay is 1 sec.

#Local Msg
#print "Send Password";
# $tMsg = "now sending user PWD\r\n";
print $tMsg;
$msgSend = "admin\r";
$sock->send($msgSend);
#required delay. Min. 100ms.  Here the delay is 1 sec.
sleep 1;  #may require delay. Min. 100ms.  Here the delay is 1 sec.

#Optinal - to capture and see what's going on
$sock->recv($myCap, 1024);
print $myCap;

sleep 1;

#now sending reboot command "pset 1 0"
print "Sending command \"pset 1 0\" with  '\\n\\r' only.====>working.\n\r";
$msg = "pset 1 0\n\r";
$sock->send($msg);
sleep 1;
$sock->recv($myCap, 1024);
print $myCap;
$msg = "pset 1 1\n\r";
print "Sending: $msg";
$sock->send($msg);
sleep 1;

#$sock->recv($menu, 2048);
#print $menu;

# #now sending reboot command "pset 2 0"
# print "Sending command \"pset 2 0\" with  '\\r' only.====>working.\n\r";
# $msg = "pset 2 0\r";
# $sock->send($msg);
# sleep 1;
# $msg = "pset 2 1\r";
# $sock->send($msg);
# sleep 1;

# #now sending reboot command "pset 1 0"
# #print "Sending command \"pset 1 0\" with  '\\r\\n' only.====>working.\n\r";
# #$msg = "pset 3 0\r\n";
# #$sock->send($msg);
# #sleep 1;
# #$msg = "pset 3 1\r\n";
# #$sock->send($msg);

# #Local Msg
# print "\nLoging out the system\n\r";
# $msg = "logout\r";
# $sock->send($msg);

#---------Helpful delay -----------
sleep 1;
close($sock);






