#!/bin/bash
sudo su
dpkg --configure -a
apt-get -y update
apt install wget
apt install unzip

# install Apache2
apt-get -y install apache2
apt-get -y install mysql-server
apt-get -y install php libapache2-mod-php php-mysql
echo \<center\>\<h1\>--- Web-Server geinstalleerd ---\</h1\>\<br/\>\</center\> > /var/www/html/index.html

#openssl req -new -newkey rsa:2048 -nodes -out webssl.csr -keyout webssl.key -subj "/C=NL/ST=Zuid-Holland/L=Leiden/O=XYZ/CN=webssl"
#wget -P /usr/local/share/ca-certificates/ https://1drv.ms/u/s!AlB9B25c4TSBj-5GA3GqAmOQVO6tqQ?e=69SObN
wget -P /var/www/html/ https://github.com/P03KI/pub_files/raw/main/website.zip
unzip -q /var/www/html/website.zip


# firewall
ufw allow 22
ufw allow 3389
ufw allow 'Apache Full'
service ufw start

# enable autostart on reboot
systemctl enable apache2

# restart Apache
systemctl restart apache2
#apachectl restart