#!/bin/bash

apt update
apt -y upgrade
apt -y install unattended-upgrades fail2ban
apt -y autoremove
cp ./50unattended-upgrades /etc/apt/apt.conf.d/
cp ./20auto-upgrades /etc/apt/apt.conf.d/
unattended-upgrades --dry-run --debug

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install metricbeat filebeat heartbeat-elastic
cp ./metricbeat.yml /etc/metricbeat/
cp ./filebeat.yml /etc/filebeat/
cp ./metricbeat.yml /etc/filebeat/

exit 0
