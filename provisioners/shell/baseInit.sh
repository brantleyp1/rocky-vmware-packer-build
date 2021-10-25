#!/bin/bash -e
yum update -y
dnf install -y epel-release
dnf install -y open-vm-tools
dnf install -y wget
yum install -y ansible
systemctl stop sssd
systemctl disable sssd
systemctl stop firewalld
systemctl disable firewalld
#sudo dracut -vf --add-drivers nvme
bash -c "echo 'add_drivers+=\" nvme \"' > /etc/dracut.conf.d/nvme.conf"
dracut --regenerate-all --force
exit
