#!/bin/bash
#sudo su
dpkg --configure -a
apt-get -y update
apt install wget
apt install unzip

# install Apache2
apt-get -y install apache2
apt-get -y install mysql-server
apt-get -y install php libapache2-mod-php php-mysql

#old test index
#echo \<center\>\<h1\>--- Web-Server geinstalleerd ---\</h1\>\<br/\>\</center\> > /var/www/html/index.html

#test autogenerate CA cert
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
#openssl req -new -newkey rsa:2048 -nodes -out webssl.csr -keyout webssl.key -subj "/C=NL/ST=Zuid-Holland/L=Leiden/O=XYZ/CN=webssl"

wget https://github.com/P03KI/pub_files/raw/main/website.zip
unzip website.zip -d /var/www/html/ -o


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

# #!/bin/bash
# # installeer Apache Webserver en PHP
# yum install -y httpd mysql php
# # lab bestanden downloaden
# wget https://aws-tc-largeobjects.s3.amazonaws.com/CUR-TF-100-RESTRT-1/80-lab-vpc-web-server/lab-app.zip
# unzip lab-app.zip -d /var/www/html/
# # schakel webserver in
# chkconfig http on
# service httpd start
