# rocky-vmware-packer-build
building vmware vm of rocky using packer with percentage based kickstart

## Purpose

This builder is based on Rocky 8.4 but should be compatible with almost no change for AlmaLinux or Centos/RHEL builds. 

## Index of files

provisioners - directory where shell scripts and/or ansible plays/roles can live. I hvae my hardening role up a level and centralized, but mine is based on [this role](https://github.com/HarryHarcourt/Ansible-RHEL8-CIS-Benchmarks).

kickstart.cfg - this is just a copy of whichever is needed for a given need

rocky.kickstart-home.cfg - the version of the config I use for vms at home on Proxmox

rocky.kickstart-percent.cfg - the version of the config used at work. Note, it does some things like setting new user home directories to be at /export/home to enable autofs home mounting at /home. It's not needed, but ensures home directories aren't mounted over.


Both kickstart files set up separate partitions for /var, /var/tmp, /var/log, /home and /tmp. 


rocky.prox.json - the json packer build for proxmox

rocky.vmware.json - the json packer build for locally running vmware

rocky.vsphere.json - the json packer build for vmware/vcenter

## Options

Some things I've learned along the way. 

* Packer builds an http listener to allow the system to pull down the kickstart.cfg file. You can use something like `ks=http://{{ .HTTPIP }}:{{ .HTTPPort}}/kickstart.cfg` to have it pull from the current working directory, or most exmples have an http directory where the file lives. You can also use a static ip from another system, i.e. `ks=http://10.10.10.27/ks/rocky.kickstart-percent.cfg` where the file is just sitting at a www/ root or something. It is probably possible to have it at a github link, but you would have to have the exact uri for the file.

* The hardening role has a lot of options, make sure you're aware and comfortable with each. Some will completely lock you out of a system, some will cause issues downsteam.

* The percentages might cause issues for total hard drive sizes under ~10Gig, as 5% of that isn't a lot of space for /var/log. Make sure to either bump up that percentage as needed or use larger volumes.
