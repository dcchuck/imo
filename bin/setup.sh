#!/usr/bin/env bash

BASEDIR=$(basename $PWD)
echo "Note: IMO Setup script assumes the following dependencies are" \
     "installed: Vagrant, VirtualBox, and dnsmasq or etc/hosts for dev domain" \
     "forwarding."

echo "Removing old versions of .ruby-version and .rbenv-gemsets..."
rm -f .ruby-version
rm -f .rbenv-gemsets
echo "2.2.3" > .ruby-version
echo "Setting up database YML files from templates."
cp config/database.EXAMPLE.yml config/database.yml
rm -f ~/.pow/$BASEDIR

if ! gem list rb-fsevent -i > /dev/null 2>&1; then
  echo "Installing rb-fsevent for rsync monitoring..."
  gem install rb-fsevent
fi

echo "Installing vagrant plugins..."
vagrant plugin install landrush
vagrant plugin install vagrant-triggers
echo "Provisioning vagrant..."
vagrant up --provision
