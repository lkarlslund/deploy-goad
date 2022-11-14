# Deploy GOAD v2 on Ubuntu Linux 22.04.1 LTS

This script takes some of the pain out of deploying the Active Directory lab provided by https://github.com/Orange-Cyberdefense/GOAD

## High level description
- Ensure computer has VTx extensions enabled in BIOS
- Install Ubuntu Server 22.04.1 LTS. Recommmended at least 4 cores, 16GB RAM and SSD drive
- Run script to install prereqs
- Bring up GOAD environment

## Detailed description
For a deployment using Windows 10/11 as your host computer:

1) Get a beefy machine with Windows 10/11
2) Download VMware Workstation Player 16.0, install it
3) Download Ubuntu 22.04.1 LTS server ISO
4) Create new VM, I opted for 8 cores and 32GB RAM, 256GB SSD, point it at the ISO
5) *IMPORTANT*: also enable "Virtualize Intel VT-x/EPT or AMD-V/RVI" and "Virtualize IOMMU" under the "Processors" tab of the VM, otherwise the nested virtualization will perform *horribly*
6) Fire up the VM, install Ubuntu Server - I chose "minimal" install + SSH just in case. When done, reboot VM
7) Log in with your chosen username

Type this into the VM:

```
sudo su (give it your password)
apt install git
git clone https://github.com/lkarlslund/deploy-goad
cd deploy-goad
./deploy-goad.sh
```

Get coffee, this is the longest part. Should you get an error while the deployment is running, try re-running the script again, this can fix download problems, timeouts etc. The GOAD script only deploys the VMs once, it doesn't start all over.

After running the script you have the GOAD repository available in /opt/goad, and the VMs are deployed.

To finish configuration you just run:
```
cd /opt/goad/ansible
ansible-playbook main.yml
```

You might need to adjust your primary VM for networking, depending on how you wish to access your newly deployed lab.

Have fun!
