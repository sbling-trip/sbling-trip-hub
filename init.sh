#!/bin/bash

# vim
mkdir -p /home/sbling/.vim/colors
wget https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim -O /home/sbling/.vim/colors/gruvbox.vim

## ssh
sudo sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo touch /home/sbling/.ssh/authorized_keys
sudo cat '/home/sbling/.ssh/sbling-trip-hub.pub' >> /home/sbling/.ssh/authorized_keys
sudo chmod 600 /home/sbling/.ssh/authorized_keys
sudo service ssh start

# log all services
sudo service --status-all

# Start docker
sudo start-docker.sh

# Your commands go here
# git clone https://github.com/cruizba/ubuntu-dind
# docker run --privileged ubuntu-dind-test docker run hello-world
sudo docker-compose up -d

/bin/bash