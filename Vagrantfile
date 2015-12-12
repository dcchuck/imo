VAGRANTFILE_API_VERSION = "2"

Vagrant.configure('2') do |config|
  config.vm.box = "ubuntu/trusty64"

  # https://github.com/mitchellh/vagrant/issues/5186 (one of possible fixes)
  config.ssh.insert_key = false

  # https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']

    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      total_memory = "grep 'MemTotal' /proc/meminfo | "\
                     "sed -e 's/MemTotal://' -e 's/ kB//'"
      mem = `#{total_memory}`.to_i / 1024 / 4
    else
      cpus = 2
      mem = 2048
    end

    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
    vb.customize ["guestproperty",
                  "set",
                  :id,
                  "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold",
                  10000]
  end

  config.vm.network :private_network, type: 'dhcp'
  config.vm.network :forwarded_port, guest: 80, host: 8080
  # config.vm.network :forwarded_port, guest: 443, host: 8443

  # Websockets
  # config.vm.network :forwarded_port, guest: 3002, host: 3002

  # Use google DNS, helps with apt DNS resolving issues
  config.landrush.enabled = true
  config.landrush.tld = "tdev"

  config.vm.provision :shell, inline: "echo 'nameserver 8.8.8.8' | "\
                                      "tee /etc/resolv.conf > /dev/null"

  config.vm.synced_folder ".", "/srv/imo"
  config.vm.synced_folder ".", "/home/vagrant/imo", type: "rsync",
    rsync__auto: "true",
    rsync__args: ["--verbose", "--archive", "--delete", "-z"],
    rsync__exclude: ["node_modules/", ".git/", "tmp/"]

  config.vm.provision :shell, inline: "apt-get -y install git"
  config.vm.provision :shell, inline: "apt-get -y install zsh"

  # Postgre 9.4 apt source #####################################################
  update_packages = "echo deb http://apt.postgresql.org/pub/repos/apt/ " \
                    "trusty-pgdg main | sudo tee -- " \
                    "/etc/apt/sources.list.d/pdpg.list"
  download_pgkeys = "wget --quiet -O - https://www.postgresql.org/media/keys/" \
                    "ACCC4CF8.asc | sudo apt-key add -"

  config.vm.provision :shell, inline: update_packages
  config.vm.provision :shell, inline: download_pgkeys
  # End apt preparation for PostgreSQL #########################################

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "chef/cookbooks"]
    chef.add_recipe "apt"
    chef.add_recipe "vim"
    chef.add_recipe "nginx"
    chef.add_recipe "recipe[imo::postgresql]"
    chef.add_recipe "recipe[imo::platform]"
  end

  scripts_path = "./chef/cookbooks/imo/scripts/"
  config.vm.provision :shell, path: scripts_path + "install_zsh.sh"
  config.vm.provision :shell, path: scripts_path + "after_provision.sh"
  config.vm.provision :shell,
                      path: scripts_path + "install_rbenv.sh",
                      privileged: false

  # Setup port forwarding, start rsync watcher and start Puma once
  # provisioning is done. Add certs to system keychain.
  config.trigger.after [:provision, :up, :reload] do
    system('./chef/cookbooks/imo/scripts/forward_ports.sh')
    system('./chef/vagrant-rsync-watcher.rb &>/dev/null &')
    imo = "./imo/chef/cookbooks/imo/scripts/start_server.sh"
    run_remote("sudo -u vagrant #{imo}")
  end

  # Disable port forwarding on shutdown, remove self-signed certs from Host.
  config.trigger.after [:halt, :destroy] do
    system('./chef/cookbooks/imo/scripts/stop_forwarding_ports.sh')
    stop_rsync = "ps aux | grep -ie rsync-watcher | grep -v grep | "\
                 "awk '{print $2}' | xargs kill -9"
    system(stop_rsync)
  end
end
