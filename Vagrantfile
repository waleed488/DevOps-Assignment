# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Linux Vagrant box (CentOS Stream 9 / EuroLinux approved box)
  config.vm.box = "eurolinux-vagrant/centos-stream-9"

  # VM Hostname
  config.vm.hostname = "devops-lab-vm"

  # Port Forwarding: Map host port 8080 to guest VM port 80
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # VirtualBox Provider Configuration (1 CPU, 1024 MB RAM)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "DevOps-Assignment-VM"
    vb.cpus = 1
    vb.memory = "1024"
  end

  # Shell Provisioning Script execution
  config.vm.provision "shell", path: "provision.sh"
end
