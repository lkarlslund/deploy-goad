# Deploy GOAD v2 on Ubuntu Linux 22.04 LTS

This script takes some of the pain out of deploying the Active Directory lab provided by https://github.com/Orange-Cyberdefense/GOAD

- Ensure computer has VTx extensions enabled in BIOS
- Install Ubuntu Server 22.04. Recommmended at least 4 cores, 16GB RAM and SSD drive
- Run script to install prereqs
- Bring up GOAD environment

After running the script you have the GOAD repository available in /opt/goad, and the VMs are deployed.

To finish configuration you just run:
- cd /opt/goad/ansible
- ansible-playbook main.yml

