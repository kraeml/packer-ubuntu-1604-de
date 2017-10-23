# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  # VMware Fusion.
  # `vagrant up vmware --provider=vmware_fusion`
#  config.vm.define "vmware" do |vmware|
#    vmware.vm.hostname = "rdf-dev"
#    vmware.vm.box = "file://builds/virtualbox-ubuntu1604-17.10.23-11.box"
#    vmware.vm.network :private_network, ip: "192.168.3.2"
#
#    config.vm.provider :vmware_fusion do |v, override|
#      v.gui = false
#      v.vmx["memsize"] = 1024
#      v.vmx["numvcpus"] = 1
#    end
#
#    config.vm.provision "shell", inline: "echo Hello, World"
#  end

  # VirtualBox.
  # `vagrant up virtualbox --provider=virtualbox`
  config.vm.define "virtualbox" do |virtualbox|
    virtualbox.vm.hostname = "rdf-dev"
    virtualbox.vm.box = "file://builds/virtualbox-ubuntu1604-17.10.23-11.box"
    virtualbox.vm.network :private_network, ip: "172.22.3.2"

    config.vm.provider :virtualbox do |v|
      v.gui = true
      v.memory = 2048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    config.vm.provision "shell", inline: "echo Hello, World"
  end

end
