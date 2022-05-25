#!/bin/bash
# COMPLETELY UNINSTALL APACHE-MYSQL-PHP IN UBUNTU 16.04+
# USE THIS IF YOU NEED TO HAVE A FRESH INSTALATION OR IF ITS GET CORRUPTED/BROKEN.
# PLEASE BACKUP YOUR WEBSITE DATABASE OR INSTALLATION BEFORE RUNNING THIS SCRIPT.
# THIS WILL ALSO REMOVE ANY MYSQL DATABASE ALSO.
# VERSION 1.0 25 MEI 2022

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# Remove any pending packages
apt-get autoremove;
# Uninstall MySQL completely and old repo
service mysql stop;
apt-get --yes purge phpmyadmin;
rm -rf /etc/phpmyadmin/;
rm -rf /var/lib/phpmyadmin;
rm -rf /usr/share/phpmyadmin;
rm -rf /etc/mysql/;
rm -rf /var/lib/mysql;
rm -rf /var/log/mysql;
rm -rf /etc/my.cnf;
killall -KILL mysql mysqld_safe mysqld;
apt-get --yes purge mysql-server mysql-client;
apt-get --yes autoremove --purge;
apt --yes purge mysql-server mysql-server-5.7 mysql-server-5.6 mysql-client-5.6 mysql-server-5.5 mysql-client-5.5 mysql-server-core-5.5 mysql-server-core mysql-client mysql-server-5.4 mysql-server-5.3 mysql-server-5.2 mysql-server-5.1;
apt-get --yes purge mysql-common;
apt-get --yes purge mysql-common-5.6;
apt-get --yes purge mysql-common-5.5;
apt-get --yes purge mysql-common-5.4;
apt-get --yes purge dbconfig-mysql;
apt-get --yes purge 'mysql-common*';
apt-get --yes purge 'mysql*';
apt-get --yes purge libmysqlclient18;
apt-get --yes purge libmysqlclient18:i386;
apt-get --yes purge dbconfig-common;
apt-get --yes remove --purge mysql-server mysql-client mysql-common;
apt-get --yes autoclean;
deluser --remove-home mysql;
delgroup mysql;
rm -rf /etc/apparmor.d/abstractions/mysql /etc/apparmor.d/cache/usr.sbin.mysqld /etc/mysql /var/lib/mysql /var/log/mysql* /var/log/upstart/mysql.log* /var/run/mysqld;
updatedb;
add-apt-repository --remove ppa:ondrej/mysql-5.5;
add-apt-repository --remove 'deb http://archive.ubuntu.com/ubuntu trusty universe';
# Uninstall PHP completely
apt-get --yes autoremove;
apt-get --yes purge php5-common;
apt-get --yes purge php5.6-common;
apt-get --yes purge php5.5-common;
apt-get --yes purge php5.4-common;
apt-get --yes purge php5.3-common;
apt-get --yes purge 'php5*';
apt-get --yes purge 'php7*';
rm -rf /etc/php5/;
rm -rf /etc/php/;
# Uninstall Apache2 completely
apt-get --yes purge apache2;
apt-get --yes remove apache2*;
apt-get --yes purge libaprutil1;
apt-get --yes remove libaprutil1;
rm -rf /etc/apache2/;
rm -rf /var/www/;
# Uninstall Wireguard completely
apt-get --yes purge wireguard;
apt-get --yes update
