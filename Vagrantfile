# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "base"
  config.vm.box = "ubuntu/trusty64"

  no_of_nodes = 3
  first_consul_server_ip = [172,20,20,11]
  no_of_nodes.times do |i|
    config.vm.define "node#{i + 1}" do |n|
      node_name = "node#{i + 1}"
      external_ip = first_consul_server_ip.clone.tap {|arr| arr[3] += i}.join('.')

      n.vm.hostname = node_name
      n.vm.network "private_network", ip: external_ip
      n.vm.provision "docker" do |d|
        d.pull_images "sumanmukherjee03/consul:0.5.0"
      end
      n.vm.synced_folder ".", "/vagrant"

      consul_env_vars = [
        "NODE_NAME=#{node_name}",
        "EXTERNAL_IP=#{external_ip}",
        "SERVER=true",
        (i == 0 ? "BOOTSTRAP=#{no_of_nodes}" : "JOIN_IP=#{first_consul_server_ip.join('.')}")
      ].map {|var| "-e #{var}"}.join(" ")

      n.vm.provision "shell",
        inline: "cd /vagrant && ./bin/run-docker-container.sh consul:0.5.0 -h #{node_name} #{consul_env_vars}"
    end
  end

  config.vm.define "dns_server" do |n|
    n.vm.hostname = "dns-server"
    n.vm.network "private_network", ip: "172.20.20.10"
    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/dnsmasq:2.68"
    end
    n.vm.synced_folder ".", "/vagrant"

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/register-containers-with-dnsmasq.sh && ./bin/run-docker-container.sh dnsmasq:2.68"
  end

  config.vm.define "mysql" do |n|
    external_ip = "172.20.20.14"
    n.vm.hostname = "mysql-server"
    n.vm.network "private_network", ip: external_ip
    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/mysql:5.7"
      d.pull_images "sumanmukherjee03/consul:mysql"
    end
    n.vm.synced_folder ".", "/vagrant"

    mysql_env_vars = [
      "USER=root",
      "PASSWD=welcome2mysql"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh mysql:5.7 -h mysql --dns 172.20.20.10 #{mysql_env_vars}"

    consul_env_vars = [
      "NODE_NAME=mysql_server",
      "EXTERNAL_IP=#{external_ip}",
      "EXTERNAL_PORT=3306",
      "SERVICE_ID=mysqldb1",
      "SERVER=false",
      "JOIN_IP=#{first_consul_server_ip.join('.')}"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh consul:mysql --link mysqlServer:mysqlServer -h mysql_server #{consul_env_vars}"
  end

  config.vm.define "postgres" do |n|
    n.vm.hostname = "postgres-server"
    n.vm.network "private_network", ip: "172.20.20.15"
    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/postgres:9.1"
      d.pull_images "sumanmukherjee03/consul:postgres"
    end
    n.vm.synced_folder ".", "/vagrant"

    postgres_env_vars = [
      "USER=root",
      "PASSWD=welcome2psql"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh postgres:9.1 -h postgres --dns 172.20.20.10 #{postgres_env_vars}"

    consul_env_vars = [
      "NODE_NAME=postgres_server",
      "EXTERNAL_IP=172.20.20.15",
      "SERVER=false",
      "JOIN_IP=#{first_consul_server_ip.join('.')}"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh consul:postgres --link postgresServer:postgresServer -h postgres_server #{consul_env_vars}"
  end

  config.vm.define "rails" do |n|
    external_ip = "172.20.20.16"
    n.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    n.vm.hostname = "rails-server"
    n.vm.network "private_network", ip: external_ip
    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/rails:onbuild"
      d.pull_images "sumanmukherjee03/consul:rails"
    end
    n.vm.synced_folder ".", "/vagrant"

    n.vm.provision "shell",
      inline: "mkdir -p /opt/app/current"
    n.vm.synced_folder "~/Work/lp-webapp", "/opt/app/current"

    rails_env_vars = [
      "RAILS_ENV=development",
      "DB_HOST=mysqldb.dev",
      "DB_DATABASE=webapp",
      "DB_USER=root",
      "DB_PASSWORD=welcome2mysql",
      "WEBAPP_USER_PREFIX=suman"
    ].map {|var| "-e #{var}"}.join(" ")

    # n.vm.provision "shell",
      # inline: "docker build -t sumanmukherjee03/rails:app -f /opt/app/current/CustomDockerfile /opt/app/current"

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh rails:app -h rails --dns 172.20.20.10 #{rails_env_vars}"

    consul_env_vars = [
      "NODE_NAME=rails_server",
      "EXTERNAL_IP=#{external_ip}",
      "EXTERNAL_PORT=3000",
      "SERVICE_ID=railsapp1",
      "SERVER=false",
      "JOIN_IP=#{first_consul_server_ip.join('.')}"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh consul:rails --link railsServer:railsServer -h rails_server #{consul_env_vars}"
  end

  config.vm.define "nginx" do |n|
    n.vm.hostname = "nginx-server"
    n.vm.network "private_network", ip: "172.20.20.17"
    n.vm.synced_folder ".", "/vagrant"

    n.vm.provision "shell", path: "bin/setup-consul-template.sh"

    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/nginx:passenger-nginx"
      d.pull_images "sumanmukherjee03/consul:nginx"
    end

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh nginx:passenger-nginx -h nginx --dns 172.20.20.10"

    n.vm.provision :shell, :inline => "cp /vagrant/upstart_configurations/nginx-consul-template.conf /etc/init/nginx-consul-template.conf", run: "always"
    n.vm.provision :shell, :inline => "sudo initctl emit vagrant-ready", run: "always"
    consul_env_vars = [
      "NODE_NAME=nginx_server",
      "EXTERNAL_IP=172.20.20.17",
      "SERVER=false",
      "JOIN_IP=#{first_consul_server_ip.join('.')}"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh consul:nginx --link nginxServer:nginxServer -h nginx_server #{consul_env_vars}"
  end

  config.vm.define "node" do |n|
    n.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    n.vm.hostname = "node-server"
    n.vm.network "private_network", ip: "172.20.20.18"
    n.vm.provision "docker" do |d|
      d.pull_images "sumanmukherjee03/node:onbuild"
      d.pull_images "sumanmukherjee03/consul:node"
    end
    n.vm.synced_folder ".", "/vagrant"

    n.vm.provision "shell",
      inline: "mkdir -p /opt/app/current"
    n.vm.synced_folder "~/Work/lp-builder", "/opt/app/current"

    node_env_vars = [
      "NODE_ENV=development"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "docker build -t sumanmukherjee03/node:app -f /opt/app/current/CustomDockerfile /opt/app/current"

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh node:app -h node --dns 172.20.20.10 #{node_env_vars}"

    consul_env_vars = [
      "NODE_NAME=node_server",
      "EXTERNAL_IP=172.20.20.18",
      "SERVER=false",
      "JOIN_IP=#{first_consul_server_ip.join('.')}"
    ].map {|var| "-e #{var}"}.join(" ")

    n.vm.provision "shell",
      inline: "cd /vagrant && ./bin/run-docker-container.sh consul:node --link nodeServer:nodeServer -h node_server #{consul_env_vars}"
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "default.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
