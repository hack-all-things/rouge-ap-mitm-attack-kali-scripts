#!/bin/bash

# 			example cfg  	my cfg
# inet conn IP		192.168.0.12	192.168.86.40
# inet gw IP		192.168.0.1	192.168.86.1

# rouge AP Interface	wlan0		wlan1
# rouge AP IP		192.168.1.1	10.0.0.1
# rouge AP gw IP

sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove 
sudo apt --yes install build-essential linux-headers-`uname -r`
sudo apt install dkms realtek-rtl88xxau-dkms
sudo apt-get install isc-dhcp-server

lsusb # shows all connected USB devices. If your rouge AP USB NIC doesn't show, unplug it and plug it back in. If that doesnt work, reboot.
iwconfig # should show wlan1

#create dhcpd.conf. This will overwrite any existing conf.
sudo tee /etc/dhcpd.conf <<EOF
authoritative;
default-lease-time 600;
max-lease-time 7200;
subnet 10.0.0.0 netmask 255.255.255.0 {
option routers 10.0.0.1;
option subnet-mask 255.255.255.0;
option domain-name "freewifi";
option domain-name-servers 10.0.0.1;
range 10.0.0.10 10.0.0.40;
}
EOF

sudo airmon-ng # tells you the name of the rouge AP interface for use in the next line.
sudo airmon-ng start wlan1 # this starts monitor mode. Make sure wlan1 is the right one. change here if needed.
# NOTE: when monitor mode gets enabled here, the name of it (for use later) will be "wlan1" (or whatever your rouge AP interface is)

# at this point, you need to open a second terminal window to continue setup with rouge-wifi-setup-2.sh
echo "**************************************************************************"  
echo "Open a second terminal window to continue setup with rouge-wifi-setup-2.sh"
echo "**************************************************************************"  
echo ""  
sudo airbase-ng -c 11 -e freewifi wlan1 # make sure the name of the interface (wlan1) and AP (freewifi) is the same here as in the dhcpd.conf (above)

