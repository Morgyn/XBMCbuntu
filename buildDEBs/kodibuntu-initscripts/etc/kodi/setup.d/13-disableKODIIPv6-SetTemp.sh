#!/bin/bash

#      Copyright (C) 2005-2013 Team KODI
#      http://www.kodi.tv
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with KODI; see the file COPYING.  If not, write to
#  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#  http://www.gnu.org/copyleft/gpl.html

kodiUser=$1
kodiParams=$2

activationToken="doNotDisableIPv6InKODI"

# if strings are the same the token is NOT part of the parameters list
# here we want to stop script if the token is NOT there
if [ "$kodiParams" != "${kodiParams%$activationToken*}" ] ; then
	exit
fi

if [ ! -f /home/$kodiUser/.kodi/userdata/advancedsettings.xml ] ; then
	mkdir -p /home/$kodiUser/.kodi/userdata &> /dev/null
	cat > /home/$kodiUser/.kodi/userdata/advancedsettings.xml << 'EOF'
<advancedsettings>
  <useddsfanart>true</useddsfanart>
  <cputempcommand>cputemp</cputempcommand>
  <gputempcommand>gputemp</gputempcommand>
  <samba>
    <clienttimeout>30</clienttimeout>
  </samba>
  <network>
    <disableipv6>true</disableipv6>
  </network>
</advancedsettings>
EOF
	chown -R $kodiUser:$kodiUser /home/$kodiUser/.kodi >/dev/null 2>&1 &
else
	if ! grep -i -q disableipv6 /home/$kodiUser/.kodi/userdata/advancedsettings.xml ; then
		if grep -i -q "<network>" /home/$kodiUser/.kodi/userdata/advancedsettings.xml ; then
			sed -i -e 's%<network>%&\n<disableipv6>true</disableipv6>%' /home/$kodiUser/.kodi/userdata/advancedsettings.xml
		else
			sed -i -e 's%<advancedsettings>%&\n<network>\n<disableipv6>true</disableipv6>\n</network>%' /home/$kodiUser/.kodi/userdata/advancedsettings.xml
		fi
	fi
fi

exit 0
