#!/bin/bash
# Bootstrap scripts for setting up an ubuntu machine

apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
