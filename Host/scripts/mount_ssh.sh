#!/bin/bash
echo "Fixing SSH permissions..." 
mkdir "/root/.ssh"
cp /root/.ssh_host/* /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id_rsa
echo "Fixing SSH permissions done"
#exec "$@"
