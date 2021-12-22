#!/bin/bash

# Make sure this is running as root.
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

# This will be passed as a kernel parameter
to_add="amd_iommu=on iommu=pt video=efif:off"

# Append it to the end of the GRUB_CMDLINE_LINUX line
sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 $to_add\"/" /etc/default/grub

# Update the grub config
grub-mkconfig -o /boot/grub/grub.cfg

# Prompt the user for a reboot
echo "Reboot to apply changes"
read -p "Reboot now? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
fi

exit 0
