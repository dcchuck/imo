#!/usr/bin/env ruby
#
# OSX's rsync doesn't poll the local FS super frequently, and this can lead to
# a bad development flow. Running this script while using vagrant will lead to
# faster updates. Shamelessly stolen from:
#
# https://github.com/mitchellh/vagrant/issues/3249
# RC - 10/30/2015
require 'rb-fsevent'

options = {:latency => 1.5, :no_defer => false }
pathRegex = /^(?!\s*#).*config.vm.synced_folder\s*"(.*?)"\s*,\s*".*?"\s*,.*?type:\s*"rsync".*/
paths = Array.new
File.open('Vagrantfile').each_line do |line|
    paths << File.expand_path($1) if pathRegex.match(line)
end
puts "Watching: #{paths}"
fsevent = FSEvent.new
fsevent.watch paths, options do |directories|
  if not directories.select { |i| !i.match("\.(git|idea|svn|hg|cvs)") }.empty?
    puts "Detected change inside: #{directories.inspect}"
    system("vagrant rsync")
  end
end
fsevent.run
