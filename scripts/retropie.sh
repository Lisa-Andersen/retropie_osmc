#!/bin/bash
cd /home/osmc/RetroPie/scripts

# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit
# moved content to retropie_starter.sh. Just kept the systemctl stop mediacenter + added the call of retropie_starter.

# stop kodi to free input devices for emulationstation
echo "retropie.sh: call retropie_starter.sh" > retropiestarter.log
sudo su osmc -c "sh /home/osmc/RetroPie/scripts/retropie_starter.sh &" &

echo "retropie.sh: done exit" >> retropiestarter.log
exit

