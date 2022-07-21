#!/bin/bash
echo "Deploy GOAD v2 on Ubuntu 22.04"

# Ensure we're on the right OS and version
if [ "`lsb_release -sd`" != "Ubuntu 22.04 LTS" ]; then
  echo "This script must be run on Ubuntu 22.04 LTS"
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
apt-get -y autoupdate

# Check if we're running inside VirtualBox
if [ `dmidecode -s system-product-name` = "VirtualBox" ]; then
  # Install VirtualBox guest additions
  apt-get install -y virtualbox-guest-utils virtualbox-guest-x11
fi

# Install base packages needed
apt-get install -y git virtualbox python3-pip

# Download GOAD
cd /opt
git clone https://github.com/Orange-Cyberdefense/GOAD goad

# Install specific version of Vagrant
wget https://releases.hashicorp.com/vagrant/2.2.18/vagrant_2.2.18_x86_64.deb
dpkg --install vagrant_2.2.18_x86_64.deb

# Set up prerequisites, not doing a venv but could be changed to that
cd /opt/goad/ansible
pip install --upgrade pip
pip install ansible-core==2.12.6
pip install pywinrm

# Install stuff needed for Ansible
ansible-galaxy install -r requirements.yml

# Install stuff needed for Vagrant
vagrant plugin install winrm
vagrant plugin install winrm-elevated

# Deploy VMs
cd /opt/goad
vagrant up

if [ $? -ne 0 ]; then
  echo "Deployment failed"
  exit 1
fi

# Configure VMs
echo "Wait some minutes for VMs to settle, then configure them:"
echo .
echo "Run these commands:"
echo "# cd /opt/goad/ansible"
echo "# ansible-playbook main.yml"
