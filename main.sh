#!/bin/bash

apt update
apt -y upgrade
apt -y install unattended-upgrades fail2ban
apt -y autoremove
cp ./50unattended-upgrades /etc/apt/apt.conf.d/
cp ./20auto-upgrades /etc/apt/apt.conf.d/
unattended-upgrades --dry-run --debug

