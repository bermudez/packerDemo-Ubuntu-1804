#!/bin/sh

set -e
set -x

date | sudo tee /etc/vagrant_box_build_time

mkdir -p ~/.ssh
#next line adds the usual (non-secure) vagrant public key (so you can use the command "vagrant ssh")
curl -fsSLo ~/.ssh/authorized_keys curl -fsSLo ~/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub

#set appropriate permissions
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys
