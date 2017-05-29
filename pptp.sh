#!/bin/bash

echo "###################################"
echo "         Install PPTP VPN          "
echo "###################################"

# Install PPTP daemon service
apt-get -y install pptpd

# Set DNS
echo "ms-dns 8.8.8.8" >> /etc/ppp/pptpd-options
echo "ms-dns 8.8.4.4" >> /etc/ppp/pptpd-options

# Get server IP
ip=`ifconfig eth0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`

# Set IP for server & user
echo "localip $ip" >> /etc/pptpd.conf
echo "remoteip 10.1.0.1-100" >> /etc/pptpd.conf

# Input username and password
echo "Membuat newuser pptp"
echo "Masukkan new user: "
read username
echo "Masukkan new password: "
read password

# Set user & password
# Replace $username and $password
echo "$username    pptpd   $password  *" >> /etc/ppp/chap-secrets

# Restart PPTPD to reload all config
service pptpd restart

# Forward packet between localip and remoteip
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# Restart sysctl to reload config
sysctl -p

# Allow PPTP traffic on iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Save iptable
iptables-save

echo "############################"
echo "  PPTP VPN Login Details    "
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Your IP is " $ip
echo "Your username is " $username
echo "Your password is " $password
echo "############################"

exit