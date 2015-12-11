#!/usr/bin/env bash

FILESDIR=/home/vagrant/imo/chef/cookbooks/imo/files

# Clean all seutp files
sudo rm -f /etc/postgresql/9.4/main/pg_hba.conf
sudo rm -f /etc/nginx/sites-available/imo
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/imo
sudo rm -f /etc/nginx/sites-enabled/default
# sudo rm -rf /etc/ssl/imo.dev

# Update postgre config
service postgresql stop
cp $FILESDIR/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
service postgresql start

# Add SSL Support & add imo to nginx
service nginx stop
# mkdir /etc/ssl/imo.dev
# cd /etc/ssl/imo.dev

# Copy over pregenerated, self-signed certs
# cp $FILESDIR/ssl/* /etc/ssl/imo.dev

# Finish nginx setup
cp $FILESDIR/nginx.conf /etc/nginx/sites-available/imo
ln -s /etc/nginx/sites-available/imo /etc/nginx/sites-enabled/imo
service nginx start

# Updated Node & NPM on ubuntu
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs
