
#!/bin/bash

# Step 1: Initialize the Kubernetes cluster
echo "[Step 1] Step 1: Initialize the Kubernetes cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy the Kube admin config
echo "[Step 2] Copy the kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy the flannel network
echo "[Step 3] Deploy the flannel network"
su - vagrant -c "kubectl create -f /vagrant/kube-flannel.yaml"

# Generate the Cluster join command
echo "[Step 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
