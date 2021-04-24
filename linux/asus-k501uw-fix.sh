#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo tee /etc/modprobe.d/asus.conf <<< "options asus_nb_wmi wapf=4"
#sudo vi /etc/pm/config.d/config
#code for the config: SUSPEND_MODULES="iwlwifi"

#echo "options asus-nb-wmi wapf=4" | sudo tee /etc/modprobe.d/asus-nb-wmi.conf
#sudo tee /etc/modprobe.d/asus.conf <<< "options asus_nb_wmi wapf=4"