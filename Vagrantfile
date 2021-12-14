# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 4
  end
  # IMPORTANT: we must update and install ca-certifcates due to the letsencrypt SSL certificate expiring.
  config.vm.provision "install", type: "shell", path: "vagrant/common.sh"
  config.vm.provision "hosts", type: "shell", inline: <<-SHELL
      sudo bash -c 'echo "191.168.50.2 kube-primary.local kube-primary" >> /etc/hosts'
      sudo bash -c 'echo "191.168.50.3 kube-worker.local kube-worker" >> /etc/hosts'
  SHELL
  config.vm.define "kube-primary" do |kp|
    kp.vm.hostname = "kube-primary"
    kp.vm.network "private_network", ip: "191.168.50.2"
    kp.vm.provision "configure", type: "shell", path: "vagrant/control.sh"
  end
  config.vm.define "kube-worker" do |kw|
    kw.vm.hostname = "kube-worker"
    kw.vm.network "private_network", ip: "191.168.50.3"
    kw.vm.provision "configure", type: "shell", path: "vagrant/worker.sh"
  end
end