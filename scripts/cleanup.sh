#!/bin/bash -eux

DISK_USAGE_BEFORE_CLEANUP=$(df -h)

# Uninstall Ansible and remove PPA.
# apt -y remove --purge ansible
# apt-add-repository --remove ppa:ansible/ansible

UBUNTU_VERSION=$(lsb_release -sr)
if [[ ${UBUNTU_VERSION} == 16.04 ]] || [[ ${UBUNTU_VERSION} == 16.10 ]] || [[ ${UBUNTU_VERSION} == 17.04 ]]; then
    # from https://github.com/cbednarski/packer-ubuntu/blob/master/scripts-1604/vm_cleanup.sh#L9-L15
    # When booting with Vagrant / VMware the PCI slot is changed from 33 to 32.
    # Instead of eth0 the interface is now called ens33 to mach the PCI slot,
    # so we need to change the networking scripts to enable the correct
    # interface.
    #
    # NOTE: After the machine is rebooted Packer will not be able to reconnect
    # (Vagrant will be able to) so make sure this is done in your final
    # provisioner.
    sed -i "s/ens33/ens32/g" /etc/network/interfaces
fi

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 2" >> /etc/network/interfaces
echo "==> Cleaning up tmp"
rm -rf /tmp/*

# Apt cleanup.
apt autoremove
apt-get --yes clean
apt-get --yes autoclean

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;


echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

# Delete unneeded files.
rm -f /home/vagrant/*.sh

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

echo "==> Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "==> Disk usage after cleanup"
df -h
