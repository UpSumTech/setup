# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define "dns_server" do |n|
    n.vm.provider "virtualbox"
    n.vm.hostname = "dns-server"
    n.vm.network "private_network", ip: "172.20.20.11"
  end

  no_of_nodes = 3
  first_consul_server_ip = [172,20,20,12]
  no_of_nodes.times do |i|
    config.vm.define "node#{i + 1}" do |n|
      n.vm.provider "virtualbox"
      n.vm.hostname = "consulnode1.dev"
      n.vm.network "private_network", ip: first_consul_server_ip.clone.tap {|arr| arr[3] += i}.join('.')
    end
  end

  config.vm.define "mysql" do |n|
    n.vm.provider "virtualbox"
    n.vm.hostname = "mysqldb1.dev"
    n.vm.network "private_network", ip: "172.20.20.15"
  end

  config.vm.define "postgres" do |n|
    n.vm.provider "virtualbox"
    n.vm.hostname = "postgresdb1.dev"
    n.vm.network "private_network", ip: "172.20.20.16"
  end

  config.vm.define "nginx" do |n|
    n.vm.provider "virtualbox"
    n.vm.hostname = "nginx1.dev"
    n.vm.network "private_network", ip: "172.20.20.17"
    # inline: "sudo initctl emit containers-ready",
  end

  config.vm.define "rails" do |n|
    n.vm.provider "virtualbox"
    n.vm.hostname = "rails1.dev"
    n.vm.network "private_network", ip: "172.20.20.18"
    n.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end
end
