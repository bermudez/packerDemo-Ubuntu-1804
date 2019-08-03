#!/bin/bash
#
#
#####
#   This script installs these packages in the Linux image:
#     dkms
#     make
#     unzip
#     groff
#     nano
#   It also installs the rest of the LAMP Stack:
#     Apache webserver
#     MySQL
#     PHP 5
#####
#  Remember to read the whole script to see additional steps to take after
#  creating the machine image (for example: setting up the DB root password).
#####

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

#install dkms and make

sudo apt-get -y install dkms
sudo apt-get -y install make

# unzip and groff are required by the aws-cli package
sudo apt-get -y install unzip
sudo apt-get -y install groff

# add other modules
sudo apt-get -y install nano

# install systemd
#sudo add-apt-repository ppa:pitti/systemd
#sudo apt-get update
#sudo apt-get dist-upgrade
#sudo apt-get install systemd-services

### Adding the rest of the LAMP stack (Apache Webserver, MySQL, PHP) and git
sudo apt-get -y update
sudo apt-get install -y apache2
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password EnterPasswordHere'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password EnterPasswordHere'
sudo apt-get -y install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get -y update
sudo apt-get -y install mysql-server php5.6-mysql
sudo mysql_install_db
sudo apt-get install -y php5.6 libapache2-mod-php5.6 php5.6-mcrypt php5.6-curl php5.6-gd php5.6-mbstring
sudo apt-get -y install curl
udo apt-get -y install aptitude
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

### Install Laravel
#cd /var/www
#git clone https://github.com/laravel/laravel.git
###

#### Note:  You still need to run mysql_secure_installation after provisioning
#    sudo mysql_secure_installation
#
####

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
