---
title: "Installing an Arch Linux VM"
hero_image: "hero.jpg"
date: 2018-10-07T22:24:25-04:00
description: "Setup guide for an Arch Linux VM along with scripts"
---

## Installing an Arch Linux VM
I use Arch Linux as my main working operating system on my laptop, as
I love how it is very bare-bones and can be configured exactly how you
like it, making it your very own experience, but at the same time not
requiring as much maintenance such as Gentoo or Linux From Scratch,
although I have yet to try others. I do respect the many other Linux
distributions, as I have tried many and like them (and see their
usability), just not as much as something that I can make my own.

Regardless, I thought it'd be a good idea to spin up an Arch VM to
experiment with new setups (and keeping my current one intact), as
well as being able to use the VM for other things, such as isolating
network traffic to school or other places for things that require LAN
access. This will also prove to be a good opportunity to write some
basic scripts to automate the process and perhaps spin up similar VMs
on other machines.

### Create the new VM and Mount the ISO onto the VM, boot into Arch Linux

### Port Forwarding on Virtualbox to Facilitate Installation through SSH
I personally use [Virtualbox](https://www.virtualbox.org/) to work
with VMs. To be able to SSH into a newly created VM, you must port
forward. To do that in Virtualbox, if you are using NAT, you must
either enter 
```
VBoxManage modifyvm vmname --natpf1"ssh,tcp,,3022,,22"
```
or you can do it via the GUI like so:
![Port Forwarding](/img/vb_portforward.png)
Note that we use port 3022 on the host in case the host already has an SSH daemon listening on port 22.

### Setting up SSH on the VM
First you should change the password of the live boot using `passwd` (just in case), after which you start the ssh service via
```
systemctl start sshd
```
Now you can SSH on the host.
```
ssh -p 3022 root@127.0.0.1
```
If you have already SSHed into another machine through local host/a different session with a different SHA256 fingerprint, you'll have to remove the old key with
```
ssh-keygen -R "[127.0.0.1]:3022"
```

### Setting up Arch Linux
I am currently trying to make some scripts to automate the
process/pre-configure various aspects. It can be found
[here](https://github.com/julianlore/GNU-Linux-Automation/tree/master/Arch). More
updates on progress later.
