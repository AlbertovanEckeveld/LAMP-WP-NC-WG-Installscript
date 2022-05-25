#!/bin/bash

# FRESH INSTALL OF LAMP SERVER IN UBUNTU 22.04+
# THIS WILL INSTALL PHP (VERSIONS) 
# BEFORE RUNNING THIS SCRIPT, MAKE SURE YOU ENTIRELY REMOVED ANY PREVIOUS APACHE-PHP-MYSQL INSTALLATION
# YOU CAN ALSO USE REMOVAL SCRIPT: uninstall.sh
# VERSION 1.0 25 MEI 2022

# Script validation checks
if [ "$(id -u)" != "0"]; then
    echo "Deze script moet met root geopend worden." 1>&2
    exit 1
fi


# --------- Installs ---------

# Run a update and upgrade
apt-get -y update && apt-get -y upgrade;

# Remove any pending packages
apt-get -y autoremove;

# Check rpl dependency
if ! type "$rpl" > /dev/null; then
    apt-get -y install rpl
fi

# Install Mysql server and client
apt-get -y install mysql-server mysql-client;

# Install Apache2
apt-get -y install apache2;

# Add PHP PPA
add-apt-repository ppa:ondrej/php;
add-apt-repository universe;

# Install PHP 7.4
apt-get -y install php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-common php7.4-gd php7.4-mbstring php7.4-fpm php7.4-json php7.4 php7.4-xml php7.4-xmlrpc php7.4-intl php7.4-curl php7.4-zip php7.4-imagick;

# Install phpmyadmin and its dependencies
#apt-get -y install phpmyadmin php7.1-mbstring php7.0-mbstring php5.6-mbstring php-gettext;

# --------- End Installs ---------


# Enable proxy_fcgi module
a2enmod proxy_fcgi setenvif;

# Enable php7.0-fpm configuration as default (not PHP 5.6 and PHP 7.1 but this can switched easily if needed)
a2enconf php7.0-fpm;

# Restart apache2 service
systemctl restart apache2;

# Update working home Apache directories
rpl "/var/www/" $1 /etc/apache2/apache2.conf;
notrailing=${1%/};
rpl "/var/www/html" $notrailing /etc/apache2/sites-available/000-default.conf;
rpl "/var/www/html" $notrailing /etc/apache2/sites-available/default-ssl.conf;

# Update user targeting default PHP 7.0/7.1/5.6 FPM
rpl "www-data" $2 /etc/php/7.1/fpm/pool.d/www.conf;
rpl "www-data" $2 /etc/php/7.0/fpm/pool.d/www.conf;
rpl "www-data" $2 /etc/php/5.6/fpm/pool.d/www.conf;
rpl "www-data" $2 /etc/apache2/envvars;

# Include phpMyadmin configuration file
#echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf;

# Enable mod modules
a2enmod ssl
a2enmod headers
a2enmod rewrite

# Enable conf mudules
a2enconf ssl-params

# Enable site modules
a2ensite default-ssl

# Generate certificate using OPENSSL
openssl rand -writerand .rnd;
echo "Naam voor certificaten .key & .crt opgeslagen in /etc/ssl";
read naam;
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/$naam-key.key -out /etc/ssl/certs/$naam-cert.crt;

# SSL-parameters
cat > /etc/apache2/conf-available/ssl-params.conf << ENDOFFILE
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
SSLSessionTickets Off
ENDOFFILE

# Configure SSL
cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak;

# Edit existing configuration file
# HIER MOET NOG CODE


# Redirect HTTP request to HTTPS
# HIER MOET NOG CODE


# Reload PHP 7.4 FPM
service php7.4-fpm reload;

# Creating info.php
echo '<?PHP Phpinfo();?>' > /var/www/html/info.php;


# --------- Firewall ---------

ufw allow "Apache Full";
ufw allow OpenSSH;
ufw allow enable;
ufw allow 51820/udp

# --------- End Firewall ---------

# Configure Mysql Database for wordpress and nextcloud
mysql -uroot -e "create database wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -uroot -e "create user 'wordpressuser'@'localhost' identified by 'P@ssw0rd'";
mysql -uroot -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost'";
FLUSH PRIVILEGES;
mysql -uroot -e "create database nextcloud DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -uroot -e "create user 'ncadmin'@'localhost' identified by 'P@ssw0rd'";
mysql -uroot -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'ncadmin'@'localhost'";
FLUSH PRIVILEGES;

# Wordpress install & configuration
wget https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz;
tar xzvf /tmp/latest.tar.gz -C /tmp/;
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php;
cp -a /tmp/wordpress/. /var/www/html/wordpress;

cat > /etc/apache2/sites-available/wordpress.conf << ENDOFFILE
<Directory /var/www/html/wordpress>
	AllowOverride All
</Directory>
ENDOFFILE

chown -R www-data:www-data /var/www/html/wordpress;
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/salt.txt;

# Configure database in the config
# HIER MOET NOG CODE

a2ensite wordpress.conf;
systemctl restart apache2;

# Nextcloud install & configuration
wget -c https://download.nextcloud.com/server/releases/latest.tar.bz2 -O /tmp/latest.tar.bz2;
tar xvf /tmp/latest.tar.bz2 -C /tmp/
cp -r /tmp/nextcloud /var/www/html/nextcloud

cat > /etc/apache2/sites-available/nextcloud.conf << ENDOFFILE
<Directory /var/www/html/nextcloud>
	AllowOverride All
</Directory>
ENDOFFILE

chown -R www-data:www-data /var/www/html/nextcloud;
a2ensite nextcloud.conf;
systemctl restart apache2;

# Restart & test apache2
service apache2 restart;
apache2ctl configtest;

# Wireguard install & configuration

apt-get -y install wireguard;

wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey

cat > /etc/wireguard/wg0.conf << ENDOFFILE
[Interface]
Address = 10.0.10.1/24
SaveConfig = true
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820
PrivateKey = SERVER PRIVATE KEY
ENDOFFILE

chmod 600 /etc/wireguard/{privatekey,wg0.conf}

wg-quick up wg0
ip a show wg0

# Remove unused downloaded files
rm -dr /tmp/nextcloud
rm -dr /tmp/wordpress
rm /tmp/latest.tar.gz
rm /tmp/latest.tar.bz2

# Done message
echo "You have successfully installed LAMP + nextcloud + Wireguard on your Ubuntu server";