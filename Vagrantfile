# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
     
    # Apache HTTP Server
    config.vm.define "web" do |app|
      app.vm.hostname = "web"
      app.vm.network "private_network", ip: "192.168.33.10"
      app.vm.provision "shell", path: "provision-for-apache.sh"
    end
  
    # MySQL Server
    config.vm.define "db" do |app|
      app.vm.hostname = "db"
      app.vm.network "private_network", ip: "192.168.33.11"
      app.vm.provision "shell", path: "provision-for-mysql.sh"
    end

end
