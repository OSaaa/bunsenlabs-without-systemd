#!/bin/bash
echo "-----------------------"                      
echo "This script will convert Devuan Jessie 1.0.0 LTS for amd64 into bunsenlabs 8.7" 
echo "(last stable at the time of release)."
echo "                                              "
echo "In theory it should work with any Debian distro (and the next Devuan versions"
echo "that integrate s6, runit or any  init system other than sysvinit), but it has only been tested"
echo "under a normal desktop usage with the sysvinit version (the only one currently available)."
echo "in order to ensure its perfect operation,             "
echo "please install Devuan without any desktop environment"
echo "(the option is under Graphical Expert Install)."
echo "                                   "
echo "Also, make sure you have a working Internet connection."
echo "This script will require super-user privileges in order to make the following changes:"
echo "It will add the bl repos, their respective gpg key, install the required packages,"
echo "Allow a user to reboot or shutdown the machine without super-user privileges,"
echo "And then fix the bl-exit application so it shuts down using working sysvinit commands."
echo "-----------------------"                      
su
echo "deb http://pkg.bunsenlabs.org/debian bunsen-hydrogen main" | tee -a /etc/apt/sources.list
wget https://pkg.bunsenlabs.org/debian/pool/main/b/bunsen-keyring/bunsen-keyring_2016.7.2-1_all.deb
dpkg -i bunsen-keyring_2016.7.2-1_all.deb
apt-get update
apt install openbox pulseaudio bunsen-meta-all
apt purge xfce4-notifyd
chmod 777 /sbin/shutdown
cp bl-exit /usr/bin/bl-exit
echo "We need to install your GPU driver. Do you have ATi/AMD (a) or NVIDIA (n)?"
while true; do
read -rsn1 input
if [ "$input" = "a" ]; then
apt install xserver-xorg-video-radeon xserver-xorg-video-ati
elif ["$input" = "n" ]; then
apt install xserver-xorg-video-nvidia xserver-xorg-video-nouveau
fi
echo "Done. Please reboot if the drivers were installed successfully."
exit
