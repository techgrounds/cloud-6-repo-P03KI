#!/bin/bash
sudo su 
# wget -P /var/www/html/ https://sto75fd25akpspm6.blob.core.windows.net/website/website.zip
# apt install unzip
# unzip -q /var/www/html/website.zip
wget -P /var/www/html/ https://1drv.ms/u/s!AlB9B25c4TSBj-8pPJ9z1cKbYuu24w?e=v1ekB5   
apt install unzip
unzip -q /var/www/html/website.zip
wget -P /usr/local/share/ca-certificates/ https://1drv.ms/u/s!AlB9B25c4TSBj-5GA3GqAmOQVO6tqQ?e=69SObN