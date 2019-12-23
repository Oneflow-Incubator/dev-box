# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  (1..3).each do |i|
    config.vm.define  node_name = "node-#{i}" do |node|
      # echo flags from cli
      node.vm.provision "shell",
        inline: "echo from node #{i}"

      # box config
      node.vm.box = "xxmyjk/oneflow-devbox"
      node.vm.box_version = "1.0.0"

      # host & network config
      node.vm.hostname = node_name

      # hardware config
      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end

      node.vm.network "forwarded_port", guest: 22, host: "220#{i}"
      node.vm.network "private_network", ip: "192.168.33.10#{i}"

      node.vm.provision "shell", inline: <<-SHELL
        echo "Hello, vagrant!"
      SHELL
    end
  end
end
