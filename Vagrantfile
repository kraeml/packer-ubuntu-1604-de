# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "rdf" do |rdf|
      rdf.ssh.insert_key = false
      rdf.vm.hostname = "rdf-dev"
      rdf.vm.box = "file://builds/virtualbox-ubuntu1604-RDF-17.12.03-21.box"
      rdf.vm.network :private_network, ip: "172.22.3.2"

      config.vm.provider :virtualbox do |v|
          v.gui = true
          v.memory = 2048
          v.cpus = 2
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--ioapic", "on"]
      end

      config.vm.provision "shell", inline: "echo Hello, World"
  end
  config.vm.define "win" do |win|
      win.vm.define "vagrant-windows-2016"
      win.vm.box = "file://builds/windows_2016_hyperv_virtualbox.box"
      win.vm.communicator = "winrm"

      # Admin user name and password
      win.winrm.username = "vagrant"
      win.winrm.password = "vagrant"

      win.vm.guest = :windows
      win.windows.halt_timeout = 15

      win.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
      win.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
      win.vm.network :private_network, ip: "172.22.3.3"
      win.vm.provision "shell",
        inline: "Set-Item WSMan:\\localhost\\Client\\TrustedHosts -Value '172.22.3.2' -Concatenate -Force"


      win.vm.provider :virtualbox do |v, override|
          v.gui = true
          v.customize ["modifyvm", :id, "--memory", 2048]
          v.customize ["modifyvm", :id, "--cpus", 2]
          v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
      end
  end
end
