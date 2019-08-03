#!/bin/bash
#
#####
#   This script installs these packages in the Linux image:
#     dkms
#     make
#     unzip
#     groff
#     nano
#   It also installs the rest of the LEMP Stack:
#     nginx
#     MariaDB
#     PHP7
#####
#  Remember to read the whole script to see additional steps to take after
#  creating the machine image (for example: setting up the DB root password).
#####

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

# install systemd
#sudo add-apt-repository ppa:pitti/systemd
#sudo apt-get update
#sudo apt-get dist-upgrade
#sudo apt-get install systemd-services

### Adding the rest of the LAMP stack (Apache Webserver, MySQL, PHP) and git
#sudo apt-get update
#sudo apt-get install -y apache2
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password EnterPasswordHere'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password EnterPasswordHere'
#sudo apt-get -y install mysql-server php5-mysql
#sudo mysql_install_db
#
### Alternative LEMP Stack (Linux, nginx, MariaDB 10.1.18, PHP 7)
# Install nginx
sudo sh -c "echo 'deb http://nginx.org/packages/ubuntu/ `lsb_release -cs` nginx' >> /etc/apt/sources.list"
sudo sh -c "echo 'deb-src http://nginx.org/packages/ubuntu/ `lsb_release -cs` nginx' >> /etc/apt/sources.list"
sudo curl http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install nginx
# Add MariaDB 10.1 Repo
sudo apt-get -y install software-properties-common
#sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'
sudo apt-get update
sudo apt-get -y --force-yes install mariadb-server
# Stop the mariadb service before proceeding to the next step
sudo service mysql stop
# Instruct MariaDB to create its database directory structure:
sudo mysql_install_db

####Start, enable & status checking systemd System
#sudo systemctl start mariadb.service
#sudo systemctl enable mariadb.service
#sudo systemctl status mariadb.service
####

# Start, enable & status checking Sysvinit System
#sudo service mysqld start
#sudo chkconfig mysqld on
# Install php5 old systems
sudo apt-get -y install php5 php5-fpm php5-mysql php5-cli php5-curl php5-gd php5-mcrypt
#Add repo for PHP 7
sudo apt-get install -y language-pack-en-base
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
# Install php7
sudo apt-get -y install php7.0 php7.0-fpm php7.0-mysql php7.0-mbstring php7.0-common php7.0-gd php7.0-mcrypt php-gettext php7.0-curl php7.0-cli php7.0-xml


#### Note:  You still need to run mysql_secure_installation after provisioning
#    sudo mysql_secure_installation
#
#### We need to make small changes on php.ini file to make it work php-fpm properly.
#    Open php.ini file on your favorite text editor and find cgi.fix_pathinfo=
#    then uncomment it and change from 1 to 0.
#  [For php5]
#  $ sudo nano /etc/php5/fpm/php.ini
#
#  [For php7]
#  $ sudo nano /etc/php/7.0/fpm/php.ini
#
#  cgi.fix_pathinfo=0
#
#### By default PHP-FPM listens the socket on fpm.sock and its not effective one.
#    So we need to change the listening settings on /etc/php5/fpm/pool.d/www.conf &
#    /etc/php/7.0/fpm/pool.d/www.conf.
#    From listen = /var/run/php5-fpm.sock & listen = /run/php/php7.0-fpm.sock
#    to listen = 127.0.0.1:9000 to listen TCP.
#    Just open the file www.conf and do it.
####
#### Open /etc/nginx/nginx.conf file on your favorite text editor and change worker_processes values
#    according your CPU count. For CPU count use lscpu command. I’m having 4 CPU’s that’s why i added 4.
#    Also check Nginx User, it should be www-data
#  $ nano /etc/nginx/nginx.conf
#
#  user www-data;
#  worker_processes 4;
####
####
#   Note : 1) When you are installing Nginx from Ubuntu Repository, it will create default conf file
#             under /etc/nginx/sites-available/default
#          2) When you are installing Nginx from Nginx Repository, it will create default conf file
#             under /etc/nginx/conf.d/default. So, don’t get confused.
#          3) Nginx Default Document Root : /usr/share/nginx/html but when you installing Nginx
#             from distribution repository, web root location will be /var/www/html.
#             It’s your wish to keep or change the location.
#################
#   Open default Virtual host configuration file /etc/nginx/sites-available/default
#   (I have installed from Ubuntu repository, so my location should be this) on your favorite text editor
#   and uncomment below lines. Also add/modify below colored lines on your file.
#   I have removed all the unwanted lines from this file for clear explanation.
#   Add your FQDN (server.2daygeek.com) instead of us.
##----------------
#$ sudo nano /etc/nginx/sites-available/default
#
# Web root location & port listening #
#	server
#	{
#        listen 80;
#	server_name server.2daygeek.com;
#        root /usr/share/nginx/html;
#        index index.php index.html index.htm;
#
# Redirect server error pages to the static page #
#        location /
#	{
#	try_files $uri $uri/ /index.php;
#        }
#        error_page 404 /404.html;
#        error_page 500 502 503 504 /50x.html;
#        location = /50x.html
#	{
#        root /usr/share/nginx/html;
#        }
#
# Pass the PHP scripts to FastCGI server #
#	location ~ \.php$
#	{
#        try_files $uri =404;
#        fastcgi_pass 127.0.0.1:9000;
#	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
#        fastcgi_index index.php;
#        include fastcgi_params;
#        }
#	}
############################

### Install PHPMyAdmin, a free open-source web-based
#     administration tool for managing the MySQL, MariaDB servers which
#     will help us to manage the database easily.
sudo apt-get -y install phpmyadmin
#Create Symlink
sudo ln -s /usr/share/phpMyAdmin /usr/share/nginx/html
#Restart Nginx service]
#sudo systemctl restart nginx.service
#sudo service nginx restart

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
