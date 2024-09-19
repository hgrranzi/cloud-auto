# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "vm" do |server|
    server.vm.hostname = "vm"
    server.vm.box = "generic/alpine318"
    server.ssh.insert_key = false
    server.vm.synced_folder ".", "/deploy", type: "rsync", rsync__auto: true, rsync__exclude: ['Vagrantfile', './.vagrant']
    server.vm.provision "shell", inline: <<-SHELL
      sudo apk update
      sudo apk add curl unzip python3 py3-pip gcc musl-dev libffi-dev openssl-dev python3-dev make

      curl -o terraform.zip https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
      unzip terraform.zip
      sudo mv terraform /usr/local/bin/
      rm terraform.zip
      terraform -v

      PIP_ROOT_USER_ACTION=ignore pip install ansible
      ansible --version

      if [ -f /deploy/.env ]; then
        grep -v '^#' /deploy/.env | grep -v '^$' | sed 's/^/export /' | sudo tee -a /etc/profile > /dev/null
      else
        echo ".env file not found"
      fi
    SHELL
  end

end