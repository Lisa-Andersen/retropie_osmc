#!/bin/bash
cd /home/osmc/RetroPie/scripts

# This script stops KODI, then starts the emulationstation watchdog deamon and
# emulationstation itself.
# Script by mcobit# check for emulationstation running
# basically copied from retropie.sh (original by mcobit). Just removed the "systemctl stop mediacenter" part + wait loop while kodi is still open + inverted if-else in while-loop.

# check if emulationstation script in chroot is changed and if so, create altered script
sudo chown osmc:osmc /usr/bin/emulationstation

echo '#!/bin/bash
es_bin="/opt/retropie/supplementary/emulationstation/emulationstation"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin

if [[ $(id -u) -eq 0 ]]; then
    echo "emulationstation should not be run as root. If you used 'sudo emulationstation' please run without sudo."
    exit 1
fi
if [[ -n "$(pidof X)" ]]; then
    echo "X is running. Please shut down X in order to mitigate problems with loosing keyboard input. For example, logout from LXDE."
    exit 1
fi
$es_bin "$@"' > "/usr/bin/emulationstation"

# Shut down KODI.
echo "retropie_starter.sh: call systemctl stop mediacenter" >> retropiestarter.log 
sudo systemctl stop mediacenter 

# clear the virtaul terminal 7 screenwait
echo "retropie_starter.sh: clear the virtaul terminal 7 screen" >> retropiestarter.log 
sudo openvt -c 7 -s -f clear

# start emulationstation on vitrual terminal 7 and detach it
echo "retropie_starter.sh: start emulationstation on virtual terminal 7" >> retropiestarter.log 
sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation >/dev/null 2>&1"

# start the watchdog script
echo "retropie_starter.sh: start the watchdog script" >> retropiestarter.log 
sudo su osmc -c "sh /home/osmc/RetroPie/scripts/retropie_watchdog.sh" 

# clear the screen again
echo "retropie_starter.sh: clear the screen again" >> retropiestarter.log
sudo openvt -c 7 -s -f clear 

exit

