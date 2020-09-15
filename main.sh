#!/bin/bash

apt update
apt -y upgrade
apt -y install unattended-upgrades fail2ban
apt -y autoremove
cp ./50unattended-upgrades /etc/apt/apt.conf.d/
cp ./20auto-upgrades /etc/apt/apt.conf.d/
unattended-upgrades --dry-run --debug

sudo apt-get install apt-transport-https
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install metricbeat filebeat heartbeat-elastic
sed -i 's/localhost:9200/download.trojan.link:9269/g' filebeat.yml
cp ./metricbeat.yml /etc/metricbeat/
cp ./filebeat.yml /etc/filebeat/
cp ./metricbeat.yml /etc/filebeat/

exit 0
