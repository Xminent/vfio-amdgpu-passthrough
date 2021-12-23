#!/bin/bash
# Helpful to read output when debugging
set -x

# Load the config file with our environmental variables
source "/etc/libvirt/hooks/kvm.conf"

# Unbind the GPU from it's drivers
echo -n "0000:${GPU}.0" >/sys/bus/pci/drivers/amdgpu/unbind || echo "Failed to unbind gpu from amdgpu"
echo -n "0000:${GPU}.1" >/sys/bus/pci/drivers/snd_hda_intel/unbind || echo "Failed to unbind gpu-audio from its original driver"

# Load the vfio-pci driver
modprobe vfio-pci

# Hand GPU to vfio-pci
echo -n "${GPU_ID}" >/sys/bus/pci/drivers/vfio-pci/new_id
echo -n "${GPU_AUDIO_ID}" >/sys/bus/pci/drivers/vfio-pci/new_id

# Bind GPU to vfio-pci
echo -n "0000:${GPU}.0" >/sys/bus/pci/drivers/vfio-pci/bind
echo -n "0000:${GPU}.1" >/sys/bus/pci/drivers/vfio-pci/bind

# Apparently you can just remove their id after assigning it
echo -n "${GPU_ID}" >/sys/bus/pci/drivers/vfio-pci/remove_id
echo -n "${GPU_AUDIO_ID}" >/sys/bus/pci/drivers/vfio-pci/remove_id
