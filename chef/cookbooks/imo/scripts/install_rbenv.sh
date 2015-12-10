#!/usr/bin/env zsh

if [ ! -d "/home/vagrant/.rbenv" ]; then
  git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
  source /home/vagrant/.zshrc
  git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
  cd /home/vagrant
  rbenv install 2.2.3
  rbenv rehash
  rbenv global 2.2.3
  gem install bundler --no-ri --no-rdoc
  rbenv rehash

  cd /home/vagrant/imo
  bundle install
  bundle exec rake db:create
fi

