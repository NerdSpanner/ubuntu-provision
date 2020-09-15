#!/bin/bash

apt update
apt -y upgrade
apt -y install unattended-upgrades fail2ban
apt -y autoremove
cp ./50unattended-upgrades /etc/apt/apt.conf.d/
cp ./20auto-upgrades /etc/apt/apt.conf.d/
unattended-upgrades --dry-run --debug

read -p "Set-up elastic stack?: " setupelk
echo $setupelk
if [[ $setupelk == *"y"* ]]
then
        apt -y install apt-transport-https
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
        apt -y update
	apt -y install metricbeat filebeat

        read -p "Remote IP? (public ip) " elkip
        echo $elkip
        read -p "Remote Hostname? (asdf.com) " elkhost
        echo $elkhost

        sed -i 's/setup.kibana/#setup.kibana/g' /etc/metricbeat/metricbeat.yml
        echo "setup.kibana:" >> /etc/metricbeat/metricbeat.yml
        echo '  host: "https://'$elkhost':443"' >> /etc/metricbeat/metricbeat.yml
        echo 'output.elasticsearch:' >> /etc/metricbeat/metricbeat.yml
        echo '  hosts: ["'$elkip':9200"]' >> /etc/metricbeat/metricbeat.yml
        metricbeat setup
        sudo systemctl enable metricbeat
        sudo systemctl start metricbeat

        sed -i 's/setup.kibana/#setup.kibana/g' /etc/filebeat/filebeat.yml
        echo "setup.kibana:" >> /etc/filebeat/filebeat.yml
        echo '  host: "https://'$elkhost':443"' >> /etc/filebeat/filebeat.yml
        echo 'output.elasticsearch:' >> /etc/filebeat/filebeat.yml
        echo '  hosts: ["'$elkip':9200"]' >> /etc/filebeat/filebeat.yml
        filebeat setup
        sudo systemctl enable filebeat
        sudo systemctl start filebeat

fi

exit 0
