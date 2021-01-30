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
    config.vm.define "server#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "server#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{100+i}"
      # subconfig.vm.network "forwarded_port", guest: 4646, host: 4600+i, auto_correct: true
      # subconfig.vm.provision "shell", privileged: false, inline: <<-SHELL
      #   echo "Server provisionning."
      #   cd
      #   # Copy all server resources
      #   cp -pr /vagrant/resources/* .

      #   # Consul:
      #   echo "Provisionning Consul server"
      #   cd ~/consul_server

      #   screen -dmS consul \
      #     consul agent -config-dir ./consul.d

      #   echo "Consul server started. Waiting 10 seconds."
      #   sleep 10

      #   # Nomad:
      #   echo "Provisionning Nomad server"
      #   cd ~/nomad_server
      #   SERVER_IP=$(ifconfig eth1 | grep 'inet ' | awk '{print $2}')
      #   sed -i "s/^consul.*/consul { address = \\\"$SERVER_IP:8500\\\" }/" ./nomad_server.hcl
      #   sed -i "s/^bind_addr.*/bind_addr = \\\"$SERVER_IP\\\"/" ./nomad_server.hcl
      #   screen -dmS nomad \
      #     nomad agent -config /home/vagrant/nomad_server/nomad_server.hcl
      # SHELL
    end
  end

  # Setup Client hosts
  (1..CLIENT_COUNT).each do |i|
    config.vm.define "client#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname =  "client#{i}"
      subconfig.vm.network "private_network", ip: "10.0.50.#{200+i}"
      # subconfig.vm.network "forwarded_port", guest: 4646, host: 4600+i, auto_correct: true
      # subconfig.vm.network "forwarded_port", guest: 8500, host: 8500+i, auto_correct: true
      # subconfig.vm.provision "shell", privileged: false, inline: <<-SHELL
      #   echo "Client provisionning."
      #   cd
      #   # Copy all client resources
      #   cp -pr /vagrant/resources/* .

      #   # Nomad:
      #   echo "Provisionning Nomad client"
      #   cd ~/nomad_client
      #   SERVER_IP=$(ifconfig eth1 | grep 'inet ' | awk '{print $2}')
      #   sed -i "s/^consul.*/consul { address = \\\"$SERVER_IP:8500\\\" }/" ./nomad_client.hcl
      #   sed -i "s/^bind_addr.*/bind_addr = \\\"$SERVER_IP\\\"/" ./nomad_client.hcl
      #   screen -dmS nomad \
      #     nomad agent -config /home/vagrant/nomad_client/nomad_client.hcl
      # SHELL
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Common provisionning:
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    echo "Common provisionning"
    # cp -pr /vagrant/bin/ /home/vagrant/
    # echo 'export PATH=/home/vagrant/bin:$PATH' >> ~/.bashrc
    # sudo yum install -y screen net-tools lsof nmap htop
    cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
    cat ~/.ssh/authorized_keys | sort -u > ~/.ssh/authorized_keys.2
    mv ~/.ssh/authorized_keys.2 ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
  SHELL
end
