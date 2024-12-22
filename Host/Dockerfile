# Use Docker-in-Docker image as the base for Docker support
FROM docker:dind

# Install QEMU for ARM cross-platform builds and other necessary packages, along with Ansible
RUN apk add --no-cache \
    qemu qemu-system-x86_64 qemu-system-arm \
    bash curl git python3 py3-pip \
    ansible

RUN ansible-galaxy collection install community.general
    
#workaround for .ssh directory permissions on Docker
RUN apk add --no-cache \
    dos2unix

COPY ./scripts/*.sh /workspace/
RUN dos2unix /workspace/*.sh
RUN chmod +x /workspace/*.sh

RUN apk add --no-cache rsync


# Set the working directory inside the container
WORKDIR /workspace

# Set the default command to bash
CMD ["/bin/bash"]
