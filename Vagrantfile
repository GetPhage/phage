# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

#  config.vm.network "public_network", type: "dhcp", bridge: "en0: Wi-Fi (AirPort)"

  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3000, host: 5000

  config.vm.synced_folder ".", "/phage", nfs: true

  config.vm.define "vagrant"

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    #    ansible.playbook = "ansible/site.yml"
    ansible.playbook = "ansible/vagrant.yml"
#    ansible.host_vars = YAML.load(File.read('ansible/host_vars/vagrant.yml'))
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end
end
