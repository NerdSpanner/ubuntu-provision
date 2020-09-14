import os,sys

os.system("apt update")
os.system("apt -y upgrade")
os.system("apt -y install unattended-upgrades")
os.system("apt -y autoremove")

