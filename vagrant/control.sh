#! /bin/bash
# This script configures the control node

sudo kubeadm init \
    --config=/vagrant/kubeadm-config.yaml \
    --upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Create a scratch space for storing the join command
tmp_path="/vagrant/tmp"

if [ -d $tmp_path ]; then
   rm -f $tmp_path/*
else
   mkdir -p "$tmp_path"
fi

cp -i /etc/kubernetes/admin.conf $tmp_path/config
touch $tmp_path/join.sh
chmod +x $tmp_path/join.sh       


kubeadm token create --print-join-command > $tmp_path/join.sh

# Apply Calico network plugin configuration

kubectl apply -f /vagrant/calico.yaml

# Ensure the vagrant user can do stuff without sudo
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/tmp/config /home/vagrant/.kube/
sudo chown vagrant:vagrant /home/vagrant/.kube/config
EOF




