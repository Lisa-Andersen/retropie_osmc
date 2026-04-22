#!/bin/bash

# Script by mcobit

# ugly fix for people having trouble with CEC

if [ "$CECFIX" = 1 ]; then
sudo /usr/osmc/bin/cec-client -p 1 &
sleep 1
sudo kill -9 $(pidof cec-client)
fi

# deactivate the hyperion deamon if it is running

if [ "$HYPERIONFIX" = 1 ]; then
   if [ $(pgrep hyperion) ]; then
      sudo service hyperion stop
   fi
fi

# activate hyperion daemon if it is not running
if [ "$HYPERIONFIX" = 1 ]; then
   if [ ! $(pgrep hyperion) ]; then
      sudo service hyperion start
   fi
fi

# check for emulationstation running
echo "retropie_watchdog.sh: check for emulationstation running:" >> retropiestarter.log
while [ true ]; do
	VAR1="$(pgrep emulatio)"

# if emulationstation is quit, clear the screen of virtual terminal 7 and show a message

		if [ ! "$VAR1" ]; then
			echo "retropie_watchdog.sh: emulationstation is quit - clear terminal 7" >> retropiestarter.log
			sudo openvt -c 7 -s -f clear

# restart kodi			
			echo "retropie_watchdog.sh: call mediacenter (emulationstation is quit)" >> retropiestarter.log
			sudo su -c "sudo systemctl restart mediacenter &" &
# exit script
			exit
		else

# if emulationstation is still running, wait 2 seconds and check again (could probably be longer, but doesn't seem to impact performance by much)
			echo "retropie_watchdog.sh: emulationstation is running. Sleep." >> retropiestarter.log
			sleep 2

		fi
	done
	echo "retropie_watchdog.sh: exit script regularly" >> retropiestarter.log
exit
