#!/bin/bash
cd /home/osmc

# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit
# basically copied from retropie.sh (original by mcobit). Just removed the "systemctl stop mediacenter" part + wait loop while kodi is still open + inverted if-else in while-loop.

# check for emulationstation running

VAR1="$(pgrep mediacenter )"
while [ "$VAR1" ]; do
	VAR1="$(pgrep mediacenter )"
	# if Kodi/mediacenter is still running, wait 2 seconds and check again. 
	echo "retropie_starter.sh: VAR1 = '$VAR1' (mediacenter PID) => sleep 0.5" >> retropiestarter.log
	# if emulationstation is still running, wait 0.5 seconds and check again (could probably be longer, but doesn't seem to impact performance by much)
	sleep 0.5
done
	 
echo "retropie_starter.sh: VAR1 = '$VAR1' (mediacenter PID) => start retropie" >> retropiestarter.log

# clear the virtaul terminal 7 screen

echo "retropie_starter.sh: clear the virtaul terminal 7 screen" >> retropiestarter.log
sudo openvt -c 7 -s -f clear

# start the watchdog script
echo "retropie_starter.sh: start the watchdog script" >> retropiestarter.log

sudo su osmc -c "sh /home/osmc/RetroPie/scripts/retropie_watchdog.sh &" &

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


# start emulationstation on vitrual terminal 7 and detach it
echo "retropie_starter.sh: start emulationstation on virtual terminal 7" >> retropiestarter.log
# sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation >/dev/null 2>&1 &" &
sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation >/dev/null 2>&1 &" &
# sudo emulationstation &

# clear the screen again
echo "retropie_starter.sh: clear the screen again" >> retropiestarter.log
sudo openvt -c 7 -s -f clear


exit

