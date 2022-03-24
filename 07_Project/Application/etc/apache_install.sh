#!/bin/bash
sudo su
dpkg --configure -a
apt-get -y update
apt install wget
apt install unzip

wget -P /var/www/html/ https://github.com/P03KI/pub_files/raw/main/website.zip

# install Apache2
apt-get -y install apache2
apt-get -y install mysql-server
apt-get -y install php libapache2-mod-php php-mysql
#echo \<center\>\<h1\>--- Web-Server geinstalleerd ---\</h1\>\<br/\>\</center\> > /var/www/html/index.html

unzip /var/www/html/website.zip

# firewall
ufw allow 22
ufw allow 3389
ufw allow 'Apache Full'
service ufw start


# enable autostart on reboot
systemctl enable apache2
a2enmod ssl
# restart Apache
systemctl restart apache2
#apachectl restart
