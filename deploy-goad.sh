#!/bin/bash
echo "Deploy GOAD v2 on Ubuntu 22.04"

# Ensure we're on the right OS and version
if [ "`lsb_release -sd | cut -c -12`" != "Ubuntu 22.04" ]; then
  echo "This script must be run on Ubuntu 22.04"
  exit 1
fi

# Ensure we're root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Add repositories
add-apt-repository -y multiverse

# Get list of latest packages
apt-get update

# Make sure we're running on latest versions of things installed
apt-get -y dist-upgrade

# Check if we're running inside VirtualBox
if [ `dmidecode -s system-product-name` = "VirtualBox" ]; then
  # Install VirtualBox guest additions
  apt-get install -y virtualbox-guest-utils virtualbox-guest-x11
fi

# Install base packages needed
apt-get install -y git virtualbox python3-pip

# Enable IP forwarding on Ubuntu
if [ "`cat /proc/sys/net/ipv4/ip_forward`" != "1" ]; then
  # Implement in sysctl
  echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
  sysctl -p
fi

# Check if vagrant is installed
if ! dpkg -s vagrant &> /dev/null; then
  wget https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0-1_amd64.deb
  dpkg --install vagrant_2.4.0-1_amd64.deb
fi

# Set up prerequisites, not doing a venv but could be changed to that
pip install --upgrade pip
pip install ansible-core==2.12.6
pip install pywinrm

# Install stuff needed for Vagrant
vagrant plugin install winrm
vagrant plugin install winrm-elevated

# Download GOAD
if [ ! -d /opt/goad ]; then
  git clone https://github.com/lkarlslund/GOAD /opt/goad
fi

# Install GOAD stuff needed for Ansible
ansible-galaxy install -r /opt/goad/ansible/requirements.yml

# Switch to GOAD folder and deploy VMs
cd /opt/goad
./goad.sh -t install -l GOAD -p virtualbox -m local

if [ $? -ne 0 ]; then
  echo "Deployment failed"
  exit 1
fi

echo "Deployment succeeded, your lab is now up and running on the 192.168.56.0/24 network"
