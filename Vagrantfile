# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "vm" do |server|
    server.vm.hostname = "vm"
    server.vm.box = "generic/alpine318"
    server.ssh.insert_key = false
    server.vm.synced_folder ".", "/shared", type: "rsync", rsync__auto: true, rsync__exclude: ['Vagrantfile', './.vagrant']
    server.vm.provision "shell", inline: <<-SHELL
      sudo apk update
      sudo apk add curl
      curl -o terraform.zip https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
      unzip terraform.zip
      sudo mv terraform /usr/local/bin/
      rm terraform.zip
      terraform -v
    SHELL
  end

end