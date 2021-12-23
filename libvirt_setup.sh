#!/bin/bash

# Make sure this is running as root.
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root." 1>&2
    exit 1
fi

# Install the packages
pacman -S libvirt libvirt-glib libvirt-python virt-install virt-manager qemu qemu-arch-extra ovmf vde2 ebtables dnsmasq bridge-utils openbsd-netcat iptables swtpm

# Start the libvirtd service
systemctl start libvirtd

# Enable the libvirtd service
systemctl enable libvirtd

# Uncomment the # from the line unix_sock_group = "libvirt"
sed -i 's/^#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf

# Do the same for unix_sock_rw_perms = "0770"
sed -i 's/^#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

# Add the line log_filters="1:qemu" to the end of the file
echo "log_filters=\"1:qemu\"" >>/etc/libvirt/libvirtd.conf

# Add the line log_outputs="1:file:/var/log/libvirt/libvirtd.log" to the end of the file
echo "log_outputs=\"1:file:/var/log/libvirt/libvirtd.log\"" >>/etc/libvirt/libvirtd.conf

# Add your user to the libvirt group
usermod -a -G libvirt "xminent"

# Create a hooks folder for libvirt
mkdir -p /etc/libvirt/hooks

# Download the hook manager
wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu

# Make the hook executable
chmod +x /etc/libvirt/hooks/qemu

# #user = "root" to user = "xminent" for /etc/libvirt/qemu.conf
sed -i 's/^user = "root"/user = "xminent"/' /etc/libvirt/qemu.conf

# #group = "root" to group = "xminent" for /etc/libvirt/qemu.conf
sed -i 's/^group = "root"/group = "xminent"/' /etc/libvirt/qemu.conf

# Restart the libvirtd service
systemctl restart libvirtd

# Enable autostart for the virsh internal network
virsh net-autostart default

# Copy the user variables for the pci devices
cp kvm.conf /etc/libvirt/hooks/

# Create the start directory
mkdir -p /etc/libvirt/hooks/qemu.d/win10/prepare/begin/

# Copy the start file to that directory
cp start.sh /etc/libvirt/hooks/qemu.d/win10/prepare/begin/

# Create the revert directory
mkdir -p /etc/libvirt/hooks/qemu.d/win10/release/end/

# Copy the revert file to that directory
cp revert.sh /etc/libvirt/hooks/qemu.d/win10/release/end/

# Done!
echo "Done!"
