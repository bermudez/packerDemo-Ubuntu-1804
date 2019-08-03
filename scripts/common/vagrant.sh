#!/bin/sh

set -e
set -x

date | sudo tee /etc/vagrant_box_build_time

#next line adds curl 
sudo apt-get update
sudo apt-get install curl -y

mkdir -p ~/.ssh
#next line adds the usual (non-secure) vagrant public key (so you can use the command "vagrant ssh")
curl -fsSLo ~/.ssh/authorized_keys curl -fsSLo ~/.ssh/authorized_keys https://github.com/hashicorp/vagrant/blob/master/keys/vagrant.pub

#set appropriate permissions
chown vagrant:vagrant ~/.ssh
chown vagrant:vagrant ~/.ssh/authorized_keys
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys
