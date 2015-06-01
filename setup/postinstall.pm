#!/usr/bin/perl
# 
# ***** BEGIN LICENSE BLOCK *****
# Zimbra Collaboration Suite Server
# Copyright (C) 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 2014 Zimbra, Inc.
# 
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software Foundation,
# version 2 of the License.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <http://www.gnu.org/licenses/>.
# ***** END LICENSE BLOCK *****
# 

package postinstall;

sub configure {

	if (main::isEnabled("zimbra-ldap")) {
		main::runAsZimbra ("${main::ZMPROV} mcf zimbraComponentAvailable ''");
		main::runAsZimbra ("zmlocalconfig -u trial_expiration_date");
	}

  # we temporary set this to true during the install/upgrade
  main::setLocalConfig("ssl_allow_untrusted_certs", "false")
    if $main::newinstall;

  if (main::isEnabled("zimbra-mta") && $main::newinstall) {
    my @mtalist = main::getAllServers("mta");
    if (scalar(@mtalist) gt 1) { 
      main::setLocalConfig("zmtrainsa_cleanup_host", "false")
    } else {
      main::setLocalConfig("zmtrainsa_cleanup_host", "true")
    }
  }

  # enable zimbra on startup
  if ($main::platform =~ /RPL1/) {
    system("/sbin/chkconfig --add zimbra");
    system("/sbin/chkconfig zimbra on");
  } elsif ($main::platform =~ /MACOSX/) {
    if (-d "/System/Library/LaunchDaemons") {
      system("cp -f /opt/zimbra/conf/com.zimbra.zcs.plist /System/Library/LaunchDaemons");
      #system("launchctl load /System/Library/LaunchDaemons/com.zimbra.zcs.plist 2> /dev/null");
      #system("launchctl stop com.zimbra.zcs")
      #  if ($main::config{STARTSERVERS} eq "no");
    }
  }
}


sub notifyZimbra {
  if (!defined ($main::options{c}) && 1) {
    #if (main::askYN("\nYou have the option of notifying Zimbra of your installation.\nThis helps us to track the uptake of the Zimbra Collaboration Server.\nThe only information that will be transmitted is:\n\tThe VERSION of zcs installed (${main::curVersion}_${main::platform})\n\tThe ADMIN EMAIL ADDRESS created ($main::config{CREATEADMIN})\n\nNotify Zimbra of your installation?", "Yes") eq "yes") {
      if (open NOTIFY, "/opt/zimbra/libexec/zmnotifyinstall ${main::curVersion}_${main::platform} $main::config{CREATEADMIN} |") {
        while (<NOTIFY>) {
          main::progress ("$_");
        }
        close NOTIFY;
        #main::progress ("Notification complete!\n");
      } #else {
        #main::progress ("ERROR: Notification failed!\n\n");
      #}
   # } else {
   # main::progress ("Notification skipped\n");
   # }
  }
}

1
