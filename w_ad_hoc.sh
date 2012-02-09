#!/usr/bin/env bash
# la la

if [ "root" != `whoami` ]
then
	echo "Needs root premission"
	exit 2
fi
sudo /etc/init.d/network-manager stop

sudo ifconfig eth0 down
sudo ifconfig ra0 down
sudo ifconfig ra0 up

sudo iwconfig ra0 essid 'VMWlan'
sudo iwconfig ra0 mode ad-hoc


sudo ifconfig ra0 up
sudo ifconfig ra0 192.168.0.201
ifconfig
