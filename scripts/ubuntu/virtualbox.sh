#!/bin/bash
#
#
set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

sudo apt-get -y install dkms
sudo apt-get -y install make

# unzip and groff are required by the aws-cli package
sudo apt-get -y install unzip
sudo apt-get -y install groff

# add other modules
sudo apt-get -y install nano


# Install additional modules
sudo apt-get install -y git
# Note:  You still need to edit config file below in the server to make index.php in the first position
# sudo vi /etc/apache2/mods-enabled/dir.conf



# Uncomment this if you want to install Guest Additions with support for X
#sudo apt-get -y install xserver-xorg

sudo mount -o loop,ro ~/VBoxGuestAdditions.iso /mnt/
sudo /mnt/VBoxLinuxAdditions.run || :
sudo umount /mnt/
rm -f ~/VBoxGuestAdditions.iso

VBOX_VERSION=$(cat ~/.vbox_version)

if [ "$VBOX_VERSION" == '4.3.10' ]; then
  # https://www.virtualbox.org/ticket/12879
  sudo ln -s "/opt/VBoxGuestAdditions-$VBOX_VERSION/lib/VBoxGuestAdditions" /usr/lib/VBoxGuestAdditions
fi
