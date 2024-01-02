# Deploy GOAD v2 on Ubuntu Linux 22.04

This script streamlines the prerequisites needed when deploying the Active Directory lab provided by https://github.com/Orange-Cyberdefense/GOAD

## High level description
- Ensure computer has VTx extensions enabled in BIOS
- Install Ubuntu Server 22.04
- Configure networking for static IP (preferably) or DHCP, so you can reach it over your LAN
- Recommmended at least 4 cores, 24GB RAM and 160GB SSD drive
- Run script to install prereqs & bring up GOAD environment

## Detailed description

### OPTION A: Deploy on a dedicated bare metal Ubuntu machine
Really simple:

1) Download Ubuntu 22.04 Server from Canonical
2) Install using Ubuntu defaults, enable SSH server, ssh to box then follow instructions below

### OPTION B: Deploy on Windows using nested virtualization with VMware Workstation Player (not recommended, but works)
For a deployment using Windows 10/11 as your host computer:

1) Get a beefy machine with Windows 10/11
2) Download VMware Workstation Player 16.0, install it
3) Download Ubuntu 22.04 Server from Canonical
4) Create new VM, I opted for 8 cores and 32GB RAM, 256GB SSD, point it at the ISO
5) Configure network for bridged mode if you want to access it from your LAN, otherwise host-only network is good enough
6) *IMPORTANT*: also enable "Virtualize Intel VT-x/EPT or AMD-V/RVI" and "Virtualize IOMMU" under the "Processors" tab of the VM, otherwise the nested virtualization will perform *horribly*
7) Fire up the VM
8) Install using Ubuntu defaults, enable SSH server, ssh to box then follow instructions below

### Connect to your Ubuntu over SSH
To deploy, you will grab this repo, launch screen do you can reconnect if your connection drops while deployingg, and start the process. It takes quite a while to run, but it does spin up a complete environment without any intervention on your part.

Type this into the Ubuntu host:

```
sudo su (give it your password)
apt install git
git clone https://github.com/lkarlslund/deploy-goad
screen -DDR
cd deploy-goad
./deploy-goad.sh
```

Get coffee, this is the longest part. Should you get an error while the deployment is running, try re-running the script again, this can fix download problems, timeouts etc. The GOAD script only does the work that is needed, and it's OK to run it multiple times.

After running the script you have the GOAD repository available in /opt/goad, and the VMs are deployed and running. Follow the instructions in on the GOAD repository https://github.com/Orange-Cyberdefense/GOAD/blob/main/ad/GOAD/README.md

![Attack scenarios in GOAD](https://github.com/Orange-Cyberdefense/GOAD/blob/main/docs/img/diagram-GOAD_compromission_Path_dark.png)

## Using the LAB
The script enables IPv4 forwarding on the Ubuntu machine, so you can add a route on your "attack" workstation that points at the Ubuntu machine:

### Routing on Windows
```
ROUTE -P ADD 192.168.56.0 MASK 255.255.255.0 <ip-of-your-ubuntu> METRIC 1
```

### Routing on Linux
```
ip route add 192.168.56.0/24 via <ip-of-your-ubuntu>
```

Have fun!
