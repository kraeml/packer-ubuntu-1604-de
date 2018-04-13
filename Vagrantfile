# -*- mode: ruby -*-
# vi: set ft=ruby :

# ansible_local requires version >= 1.8.4 to work stably
Vagrant.require_version '>= 1.8.4'

Vagrant.configure("2") do |config|
  #required_plugins = %w[vagrant-reload vagrant-persistent-storage vagrant-triggers vagrant-vbguest vagrant-proxyconf nugrant]
  # Taken from https://github.com/gantsign/development-environment/blob/master/Vagrantfile
  required_plugins = %w[nugrant vagrant-persistent-storage]
  plugins_to_install = required_plugins.reject { |plugin| Vagrant.has_plugin? plugin }
  unless plugins_to_install.empty?
    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort 'Installation of one or more plugins has failed. Aborting.'
    end
  end
  # Get Vagrantfile dir
  vagrant_dir = __dir__

  default_vb_audio = nil
  default_vb_audiocontroler = 'ac97'
  if Vagrant::Util::Platform.windows?
    default_vb_audio  = 'dsound'
  #elsif Vagrant::Util::Platform.mac?
  #  default_vb_audio  = 'coreaudio'
  #  default_vb_audiocontroler = 'hda'
  end
  # Customizable configuration
  # See https://github.com/maoueh/nugrant
  config.user.defaults = {
    "virtualbox" => {
      "name" => "rdf-dev-vb",
      "gui" => true,
      "cpus" => 2,
      "vram" => "32",
      "accelerate3d" => "off",
      "memory" => "2048",
      "clipboard" => "bidirectional",
      "draganddrop" => "bidirectional",
      "audio" => default_vb_audio,
      "audiocontroller" => default_vb_audiocontroler
    },
    "rdf" => {
      "insert_key" => false,
      "hostname"  => "rdf-dev",
      "private_network_ip" => "192.168.3.2",
      "private_network_dummy_ip" => "192.168.22.2"
    }
  }


  config.vm.define "rdf" do |rdf|
    #rdf.persistent_storage.enabled = true
    #rdf.persistent_storage.location = '.vagrant/persistent-disk.vdi'
    #rdf.persistent_storage.size = 16_000
    #rdf.persistent_storage.mountname = 'persistent'
    #rdf.persistent_storage.filesystem = 'ext4'
    #rdf.persistent_storage.mountpoint = '/var/persistent'
    #rdf.persistent_storage.volgroupname = 'persist-vg'
    #rdf.persistent_storage.diskdevice = '/dev/sde'
    # Use persistent APT cache
    #rdf.vm.provision 'shell', inline: <<SCRIPT
    #persistent_mount='/var/persistent/var/cache/apt/archives /var/cache/apt/archives none bind 0 0'
    #mkdir -p /var/persistent/var/cache/apt/archives \
    #&& grep -q -F "${persistent_moun#t}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
    #&& mount /var/cache/apt/archives
#
    #persistent_mount='/var/persistent/usr/local/src/ansible/data /usr/local/src/ansible/data none bind 0 0'
    #mkdir -p /var/persistent/usr/local/src/ansible/data \
    #mkdir -p /usr/local/src/ansible/data \
    #&& grep -q -F "${persistent_mount}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
    #&& mount /usr/local/src/ansible/data
#SCRIPT
    rdf.ssh.insert_key = config.user.rdf.insert_key
    rdf.vm.hostname = config.user.rdf.hostname
    rdf.vm.box = "file://builds/virtualbox-ubuntu1604-SA_2-18.04.13-14.box"
    rdf.vm.network :private_network, ip: config.user.rdf.private_network_ip
    rdf.vm.network :private_network, ip: config.user.rdf.private_network_dummy_ip

    rdf.vm.provider :virtualbox do |vb|
      # Enable the VM's virtual USB controller & enable the virtual USB 2.0 controller
      vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]
      # Give the VM a name
      vb.name = config.user.virtualbox.name
      # Display the VirtualBox GUI when booting the machine
      vb.gui = config.user.virtualbox.gui

      # Customize CPU settings
      vb.cpus = config.user.virtualbox.cpus

      # Customize graphics settings
      vb.customize ['modifyvm', :id, '--vram', config.user.virtualbox.vram]
      vb.customize ['modifyvm', :id, '--accelerate3d', config.user.virtualbox.accelerate3d]

      # Customize the amount of memory on the VM
      vb.memory = config.user.virtualbox.memory

      unless config.user.virtualbox.audio.nil?
        # Enable sound
        vb.customize ['modifyvm', :id, '--audio', config.user.virtualbox.audio, '--audiocontroller', config.user.virtualbox.audiocontroller]
      end
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      # Enable host desktop integration
      vb.customize ["modifyvm", :id, "--clipboard", config.user.virtualbox.clipboard]
      vb.customize ["modifyvm", :id, "--draganddrop", config.user.virtualbox.draganddrop]

      #VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

      #file_to_disk = File.join(vagrant_dir, ".vagrant/persistent-disk.vdi")
      #unless File.exist?(file_to_disk)
      #  vb.customize ["createhd", "--filename", file_to_disk, "--size", 500 * 1024]
      #end
      #vb.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", file_to_disk]

      file_to_disk = File.join(vagrant_dir, ".vagrant/test-disk1.vdi")
      unless File.exist?(file_to_disk)
        #puts "**** Adding SATA Controller; once the first disk is there asuming we don't need to do this *****"
        #vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata", "--portcount", 4 ]
        vb.customize ["createhd", "--filename", file_to_disk, "--size", 500 * 1024]
      end
      vb.customize [
        "storageattach", :id,
        "--storagectl", "SATA Controller",
        "--port", 1, "--device", 0,
        "--type", "hdd", "--medium", file_to_disk]

      file_to_disk = File.join(vagrant_dir, ".vagrant/test-disk2.vdi")
      unless File.exist?(file_to_disk)
        vb.customize ["createhd", "--filename", file_to_disk, "--size", 500 * 1024]
      end
      vb.customize ["storageattach", :id,
        "--storagectl", "SATA Controller",
        "--port", 2, "--device", 0,
        "--type", "hdd", "--medium", file_to_disk]

      file_to_disk = File.join(vagrant_dir, ".vagrant/test-disk3.vdi")
      unless File.exist?(file_to_disk)
        vb.customize ["createhd", "--filename", file_to_disk, "--size", 500 * 1024]
      end
      vb.customize ["storageattach", :id,
        "--storagectl", "SATA Controller",
        "--port", 3, "--device", 0,
        "--type", "hdd", "--medium", file_to_disk]
    end

    config.vm.provision "shell", inline: "echo Hello, World"
  end
  #config.vm.define "win" do |win|
  #    win.vm.define "vagrant-windows-2016"
  #    win.vm.box = "file://builds/windows_2016_hyperv_virtualbox.box"
  #    win.vm.communicator = "winrm"
#
#      # Admin user name and password
#      win.winrm.username = "vagrant"
#      win.winrm.password = "vagrant"
#
#      win.vm.guest = :windows
#      win.windows.halt_timeout = 15
#
#      win.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
#      win.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true
#      win.vm.network :private_network, ip: "172.22.3.3"
#      win.vm.provision "shell",
#        inline: "Set-Item WSMan:\\localhost\\Client\\TrustedHosts -Value '172.22.3.2' -Concatenate -Force"
#
#
#      win.vm.provider :virtualbox do |v, override|
#          v.gui = true
#          v.customize ["modifyvm", :id, "--memory", 2048]
#          v.customize ["modifyvm", :id, "--cpus", 2]
#          v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
#      end
#  end
end
