#!/bin/bash

# Step 1:Update the hosts file
echo "[Step 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 kmaster.example.com kmaster
172.42.42.101 kworker1.example.com kworker1
172.42.42.102 kworker2.example.com kworker2
EOF

# Step 2:Install the docker from Docker-ce repository
echo "[Step 2] Install the docker container engine"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1

# Step 3:Enable the docker service
echo "[Step 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker

# Step 4:Disable the SELinux
echo "[Step 4] Disable the SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Step 5:Stop and disable the firewalld
echo "[Step 5] Stop and Disable the firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Step 6:Add sysctl settings
echo "[Step 6] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Step 7:Disable swap
echo "[Step 7] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Step 8:Add yum repo file for Kubernetes
echo "[Step 8] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Step 9:Install Kubernetes
echo "[Step 9] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1

# Step 10:Start and Enable kubelet service
echo "[Step 10] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# Step 11:Enable ssh password authentication
echo "[Step 11] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Step 12:Set Root password
echo "[Step 12] Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc
