# VFIO AMD Passthrough

A little tutorial for myself to remember how to set this up.

## Installation

### Modify GRUB

Modify the grub config by running the `grub_setup.sh`. The file must first be made executable using chmod. Make sure to run as **root**.

```bash
  chmod +x ./grub_setup.sh
  sudo ./grub_setup.sh
```

After this step you must be reboot and if you need to do something after just press `n` for no or stop the script using `CTRL + C`.

### Install `vendor-reset`

Since we have an AMD GPU 😔. We are prone to the infamouse reset bug. This solution attempts to resolve that. Just go to the command line and do this.

```bash
    yay -S vendor-reset-dkms-git
    echo "vendor-reset" | sudo tee /etc/modules-load.d/vendor-reset.conf
```

Congratulations!, no more reset bugs, I hope.

### Setup libvirt

You're almost at the finish line, now you just need to run `libvirt_setup.sh` and you're done. Make sure to run as **root**.

```bash
  chmod +x ./libvirt_setup.sh
  sudo ./libvirt_setup.sh
```

Nice you're done I think.
