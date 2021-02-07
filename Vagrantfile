BOX_IMAGE = "centos/7"
SERVER_COUNT = 3
CLIENT_COUNT = 2

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://10.0.0.111:3128/"
    config.proxy.https    = "http://10.0.0.111:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,10.0.0.0/24,10.0.50.0/24,.local"
  end

  # Setup Server hosts
  (1..SERVER_COUNT).each do |i|
    config.vm.define "consul-server-#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "consul-server-#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{10+i}"
    end
  end

  # Setup Server hosts
  (1..SERVER_COUNT).each do |i|
    config.vm.define "nomad-server-#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "nomad-server-#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{20+i}"
    end
  end

  # Setup Client hosts
  (1..CLIENT_COUNT).each do |i|
    config.vm.define "nomad-client-#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "nomad-client-#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{30+i}"
    end
  end

  # Setup Vault Server hosts
  (1..SERVER_COUNT).each do |i|
    config.vm.define "vault-server-#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "vault-server-#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{40+i}"
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Common provisionning:
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    echo "Common provisionning"
    cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
    cat ~/.ssh/authorized_keys | sort -u > ~/.ssh/authorized_keys.2
    mv ~/.ssh/authorized_keys.2 ~/.ssh/authorized_keys
    cp /vagrant/id_rsa ~/.ssh/
    cp /vagrant/id_rsa.pub ~/.ssh/
    chmod 600 ~/.ssh/*

  SHELL

  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    cat /vagrant/hosts | grep -v $(hostname) >> /etc/hosts
    cat /etc/hosts | sort -u > /tmp/hosts
    mv /tmp/hosts /etc/hosts
  SHELL
  
end
