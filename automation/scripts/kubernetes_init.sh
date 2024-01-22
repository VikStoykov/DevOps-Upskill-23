#!/bin/bash
set -e
set -x

RUNC_VERSION="1.1.5"
CONTAINERD_VERSION="1.6.2"
KUBERNETES_VERSION="1.26.3"
VIRTCTL_VERSION="v0.41.0"
CALICO_VERSION="3.25.0"

function install_necessery_components () {
    # Load overlay and br_netfilter 
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf 
overlay 
br_netfilter 
EOF

    sudo modprobe overlay
    sudo modprobe br_netfilter

    # Enable iptables
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-iptables  = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
net.ipv4.ip_forward                 = 1 
EOF

    # Reload modules
    sudo sysctl --system

    sudo swapoff -a
    sudo sed -i '/swap/d' /etc/fstab

    # Disable Firewall
    # sudo ufw disable

    # Download and install containerd
    wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
    sudo tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
    wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service

    sudo mkdir /etc/containerd
    sudo sh -c "containerd config default > /etc/containerd/config.toml"
    sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

    sudo cp containerd.service /lib/systemd/system/containerd.service
    sudo systemctl daemon-reload
    sudo systemctl enable --now containerd

    # Download and install runc
    wget https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64
    sudo install -m 755 runc.amd64 /usr/local/sbin/runc

    # Download and install Kubernetes
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B53DC80D13EDEF05
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update -y
    sudo apt -y install vim git curl wget kubelet=${KUBERNETES_VERSION}-00 kubeadm=${KUBERNETES_VERSION}-00 kubectl=${KUBERNETES_VERSION}-00

    # Configure crictl
    cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock 
image-endpoint: unix:///run/containerd/containerd.sock 
debug: false 
timeout: 5
EOF
}

function preprare_kubernetes () {
    sudo kubeadm config images pull --cri-socket unix:///run/containerd/containerd.sock --kubernetes-version v${KUBERNETES_VERSION}

    wget https://github.com/kubevirt/kubevirt/releases/download/${VIRTCTL_VERSION}/virtctl-${VIRTCTL_VERSION}-linux-amd64
    sudo mv virtctl-${VIRTCTL_VERSION}-linux-amd64 /usr/bin/virtctl
    sudo chmod 777 /usr/bin/virtctl
}

function start_cluster () {
    # Init cluster
    sudo kubeadm init --upload-certs --kubernetes-version=v${KUBERNETES_VERSION}  --ignore-preflight-errors=all  --cri-socket unix:///run/containerd/containerd.sock

    sudo mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    #export KUBECONFIG=/etc/kubernetes/admin.conf

    # Check for system is up and running
    # kubectl get --raw='/readyz?verbose'

    # Run cluster in single mode
    sudo kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
    sleep 10

    # Apply Calico CNI
    sudo kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico.yaml

}

install_necessery_components
preprare_kubernetes
#start_cluster

sudo mkdir /home/ubuntu/config
sudo touch /home/ubuntu/config/ready
