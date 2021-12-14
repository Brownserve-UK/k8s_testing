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
    # Disable swap
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    sudo swapoff -a
    # Install k8s et al
    sudo apt update
    sudo apt -y install kubeadm=1.21.1-00 kubelet=1.21.1-00 kubectl=1.21.1-00 docker.io bash-completion
    # Copy the network plugin config
    wget https://docs.projectcalico.org/manifests/calico.yaml
    # Enable tab completion for kubectl
    source <(kubectl completion bash)
    echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
  SHELL
  config.vm.provision "hosts", type: "shell", inline: <<-SHELL
      sudo bash -c 'echo "192.168.50.2 kube-primary.local kube-primary" >> /etc/hosts'
      sudo bash -c 'echo "192.168.50.3 kube-worker.local kube-worker" >> /etc/hosts'
  SHELL
  config.vm.define "kube-primary" do |kp|
    kp.vm.hostname = "kube-primary"
    kp.vm.network "private_network", ip: "192.168.50.2"
    kp.vm.provision "configure", type: "shell", inline: <<-SHELL
      # Initialize the cluster
      sudo kubeadm init --config=/vagrant/kubeadm-config.yaml --upload-certs | tee kubeadm-init.out
      # Ensure root has a .kube directory
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config
      # Allow the vagrant user to do things
      mkdir -p /home/vagrant/.kube
      sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
      sudo chown vagrant:vagrant /home/vagrant/.kube/config
      # Apply networking config
      kubectl apply -f calico.yaml
    SHELL
  end
  config.vm.define "kube-worker" do |kw|
    kw.vm.hostname = "kube-worker"
    kw.vm.network "private_network", ip: "192.168.50.3"
  end
end