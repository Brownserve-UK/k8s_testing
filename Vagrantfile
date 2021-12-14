# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 4
  end
  # IMPORTANT: we must update and install ca-certifcates due to the letsencrypt SSL certificate expiring.
  config.vm.provision "install", type: "shell", inline: <<-SHELL
    sudo apt-get update
    apt-get install -y git curl procps lsb-release avahi-daemon libnss-mdns wget apt-transport-https software-properties-common ca-certificates
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt -y install kubelet kubeadm kubectl docker.io
    wget https://docs.projectcalico.org/manifests/calico.yaml
  SHELL
  config.vm.provision "hosts", type: "shell", inline: <<-SHELL
      sudo bash -c 'echo "192.168.60.2 kube-primary.local kube-primary" >> /etc/hosts'
      sudo bash -c 'echo "192.168.60.3 kube-worker.local kube-worker" >> /etc/hosts'
  SHELL
  config.vm.define "kube_primary" do |kp|
    kp.vm.hostname = "kube-primary"
    kp.vm.network "private_network", ip: "192.168.50.2"
  end
  config.vm.define "kube_worker" do |kw|
    kw.vm.hostname = "kube-worker"
    kw.vm.network "private_network", ip: "192.168.50.3"
  end
end