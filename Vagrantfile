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

  # config.vm.define "rails" do |n|
    # external_ip = "172.20.20.16"
    # n.vm.provider "virtualbox" do |vb|
      # vb.memory = "1024"
    # end
    # n.vm.hostname = "rails-server"
    # n.vm.network "private_network", ip: external_ip
    # n.vm.provision "docker" do |d|
      # d.pull_images "sumanmukherjee03/rails:onbuild"
      # d.pull_images "sumanmukherjee03/consul:rails"
    # end
    # n.vm.synced_folder ".", "/vagrant"

    # n.vm.provision "shell",
      # inline: "mkdir -p /opt/app/current"
    # n.vm.synced_folder "~/Work/lp-webapp", "/opt/app/current"

    # rails_env_vars = [
      # "RAILS_ENV=development",
      # "DB_HOST=mysqldb.dev",
      # "DB_DATABASE=webapp",
      # "DB_USER=root",
      # "DB_PASSWORD=welcome2mysql",
      # "WEBAPP_USER_PREFIX=suman"
    # ].map {|var| "-e #{var}"}.join(" ")

    # # n.vm.provision "shell",
      # # inline: "docker build -t sumanmukherjee03/rails:app -f /opt/app/current/CustomDockerfile /opt/app/current"

    # n.vm.provision "shell",
      # inline: "cd /vagrant && ./bin/run-docker-container.sh rails:app -h rails --dns 172.20.20.10 #{rails_env_vars}"

    # consul_env_vars = [
      # "NODE_NAME=rails_server",
      # "EXTERNAL_IP=#{external_ip}",
      # "EXTERNAL_PORT=3000",
      # "SERVICE_ID=railsapp1",
      # "SERVER=false",
      # "JOIN_IP=#{first_consul_server_ip.join('.')}"
    # ].map {|var| "-e #{var}"}.join(" ")

    # n.vm.provision "shell",
      # inline: "cd /vagrant && ./bin/run-docker-container.sh consul:rails --link railsServer:railsServer -h rails_server #{consul_env_vars}"
  # end

  # config.vm.define "node" do |n|
    # n.vm.provider "virtualbox" do |vb|
      # vb.memory = "1024"
    # end
    # n.vm.hostname = "node-server"
    # n.vm.network "private_network", ip: "172.20.20.18"
    # n.vm.provision "docker" do |d|
      # d.pull_images "sumanmukherjee03/node:onbuild"
      # d.pull_images "sumanmukherjee03/consul:node"
    # end
    # n.vm.synced_folder ".", "/vagrant"

    # n.vm.provision "shell",
      # inline: "mkdir -p /opt/app/current"
    # n.vm.synced_folder "~/Work/lp-builder", "/opt/app/current"

    # node_env_vars = [
      # "NODE_ENV=development"
    # ].map {|var| "-e #{var}"}.join(" ")

    # n.vm.provision "shell",
      # inline: "docker build -t sumanmukherjee03/node:app -f /opt/app/current/CustomDockerfile /opt/app/current"

    # n.vm.provision "shell",
      # inline: "cd /vagrant && ./bin/run-docker-container.sh node:app -h node --dns 172.20.20.10 #{node_env_vars}"

    # consul_env_vars = [
      # "NODE_NAME=node_server",
      # "EXTERNAL_IP=172.20.20.18",
      # "SERVER=false",
      # "JOIN_IP=#{first_consul_server_ip.join('.')}"
    # ].map {|var| "-e #{var}"}.join(" ")

    # n.vm.provision "shell",
      # inline: "cd /vagrant && ./bin/run-docker-container.sh consul:node --link nodeServer:nodeServer -h node_server #{consul_env_vars}"
  # end

end
