#!/bin/bash -eux

# Upgrade System.
apt -y update && apt-get -y dist-upgrade
sleep 2
reboot
