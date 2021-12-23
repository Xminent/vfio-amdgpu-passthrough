#!/bin/bash
set -x

# Load the config file with our environmental variables
source "/etc/libvirt/hooks/kvm.conf"

# Unbind the GPU from vfio-pci
#echo -n "0000:${GPU}.0" > /sys/bus/pci/drivers/vfio-pci/unbind || echo "Failed to unbind gpu from vfio-pci"
#echo -n "0000:${GPU}.1" > /sys/bus/pci/drivers/vfio-pci/unbind || echo "Failed to unbind gpu-audio from vfio-pci"

# Remove the GPU from vfio-pci
#echo -n "${GPU_ID}" > /sys/bus/pci/drivers/vfio-pci/remove_id
#echo -n "${GPU_AUDIO_ID}" > /sys/bus/pci/drivers/vfio-pci/remove_id

# Remove vfio-pci driver
#modprobe -r vfio-pci

# Bind the GPU to it's drivers
#echo -n "0000:${GPU}.0" > /sys/bus/pci/drivers/amdgpu/bind || echo "Failed to bind gpu to amdgpu"
#echo -n "0000:${GPU}.1" > /sys/bus/pci/drivers/snd_hda_intel/bind || echo "Failed to bind gpu-audio to its original driver"

# Just this alone should be enough to readd GPU
echo 1 >/sys/bus/pci/devices/"0000:${GPU}.0"/remove
echo 1 >/sys/bus/pci/devices/"0000:${GPU}.1"/remove
echo 1 >/sys/bus/pci/rescan

# Have to restart dm to use as display again
systemctl restart display-manager
