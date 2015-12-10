#!/usr/bin/env zsh

export HOME=/home/vagrant
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

cd imo
echo 'Running bundler...'
bundle
# echo 'Installing NPM packages...'
# npm install -q
echo "Starting Puma..."
bundle exec puma -b unix:///tmp/puma.sock &>/dev/null &
