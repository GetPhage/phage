# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "public_network", type: "dhcp", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.synced_folder "/Users/romkey/src/jarvis", "/jarvis"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/jarvis.yml"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
end
