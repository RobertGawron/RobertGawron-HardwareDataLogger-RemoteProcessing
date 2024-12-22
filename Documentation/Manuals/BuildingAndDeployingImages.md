# Purpose

This document explains how to build target images for Raspberry Pi.

# Assumptions

It is assumed that you have already built the Docker image for cross-compilation and are logged into it.

# Setup

For first-time usage, you need to create an SSH key for the Docker build image and store it on the Raspberry Pi to avoid prompts for passwords during image installation.&#x20;

The keys from the Docker image will be mapped to `Target/.ssh` to avoid regenerating them each time the build image is restarted. These keys are not stored in Git (ignored in `.gitignore`).

### Steps to Use SSH Keys

1. **Generate an SSH Key Pair**

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

   This creates a public/private key pair in `~/.ssh/` (e.g., `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).
   Use the default location by pressing Enter, and set a passphrase (optional).

2. **Copy the Public Key to the Target Machine**

   Use `ssh-copy-id` to copy the key to the target machine (e.g., `192.168.1.44`):

   ```bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub robert@192.168.1.44
   ```

   Enter the password for the `robert` user (or the user you use for your Raspberry Pi) when prompted. This adds the public key to the `~/.ssh/authorized_keys` file on the target machine.

3. **Test SSH Access**

   Test if SSH key-based login works:

   ```bash
   ssh robert@192.168.1.44
   ```

   You should be able to log in without entering a password.

### Handling Directory Permissions for `.ssh`

There were some problems with directory permissions for the `.ssh` directory when it was directly mapped via `docker-compose.yml`. Permissions were set to `777`, and the SSH daemon refused to use keys with such broad permissions as it was insecure.&#x20;

To resolve this, a `mount_ssh.sh` script was created. As a result, the final step is to copy the keys to this workaround location, `~/.ssh_host`:

```bash
cp -r ~/.ssh/ ~/.ssh_host
```

# Notes

Ansible, by definition, uses snake\_case convention for filenames, so we will use this instead of camelCase as in the rest of the project.

==========================================


docker buildx bake --file docker-compose.yml


ansible-galaxy install nickjj.docker

ansible-playbook -i ansible/inventory ansible/playbook.yml


