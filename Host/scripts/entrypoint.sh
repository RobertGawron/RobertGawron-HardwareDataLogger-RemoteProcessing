#!/bin/bash
/workspace/mount_ssh.sh

ansible-galaxy collection install community.general
ansible-galaxy install geerlingguy.docker

ln -s /workspace/docker-compose.yml /workspace/ansible/files/docker-compose.yml
