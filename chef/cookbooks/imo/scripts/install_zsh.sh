#!/usr/bin/env zsh

if [ ! -d "/home/vagrant/.oh-my-zsh" ]; then
  git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
  cp /home/vagrant/imo/chef/cookbooks/imo/files/.zshrc /home/vagrant/.zshrc
  sudo chsh -s /bin/zsh vagrant
fi

