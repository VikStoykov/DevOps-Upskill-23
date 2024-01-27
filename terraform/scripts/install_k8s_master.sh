#!/bin/bash
set -e
set -x


export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${private_key}
export AWS_DEFAULT_REGION=${region}
export RUNC_VERSION=${runc_version}
export CONTAINERD_VERSION=${containerd_version}
export KUBERNETES_VERSION=${kubernetes_version}
export VIRTCTL_VERSION=${virtctl_version}
export CALICO_VERSION=${calico_version}

function install_necessery_components () {
    apt install awscli -y

}

function preprare_kubernetes () {
    hostname k8s-master
    echo "k8s-master" > /etc/hostname
    rm -rf /home/ubuntu/config > /dev/null

    kubeadm reset -f
    rm -rf /etc/cni/net.d
    rm -f $HOME/.kube/config
    sleep 10
    systemctl restart kubelet
    systemctl restart containerd
    sleep 30

    while true; do
        crictl ps > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            break
        else
            sleep 10
        fi
    done
}

function start_cluster () {
    # Init cluster
    kubeadm init --upload-certs --kubernetes-version=v$KUBERNETES_VERSION  --ignore-preflight-errors=all  --cri-socket unix:///run/containerd/containerd.sock > /tmp/restult.out

    #to get join command
    tail -2 /tmp/restult.out > /tmp/join_command.sh;
    aws s3 cp /tmp/join_command.sh s3://${s3buckit_name};
    #this adds .kube/config for root account, run same for ubuntu user, if you need it
    mkdir -p /root/.kube;
    cp -i /etc/kubernetes/admin.conf /root/.kube/config;
    cp -i /etc/kubernetes/admin.conf /tmp/admin.conf;
    chmod 755 /tmp/admin.conf

    #add kube config to ubuntu user.
    mkdir -p /home/ubuntu/.kube;
    cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config;
    chmod 755 /home/ubuntu/.kube/config

    export KUBECONFIG=/etc/kubernetes/admin.conf

    while true; do
        kubectl get pods -A | grep kube-* | grep -v "coredns" | awk '{print $3}'
        ids=$(kubectl get pods -A | grep kube-* | grep -v "coredns" | awk '{print $3}')
        if [[  $ids != *"0/1"* ]]; then
            echo "1"
            break
        fi
        sleep 10
    done

    # Apply Calico CNI
    sleep 10
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/calico.yaml

    # Apply kubectl Cheat Sheet Autocomplete
    source <(kubectl completion bash) # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
    echo "source <(kubectl completion bash)" >> /home/ubuntu/.bashrc # add autocomplete permanently to your bash shell.
    echo "source <(kubectl completion bash)" >> /root/.bashrc # add autocomplete permanently to your bash shell.
    alias k=kubectl
    complete -o default -F __start_kubectl k
    echo "alias k=kubectl" >> /home/ubuntu/.bashrc
    echo "alias k=kubectl" >> /root/.bashrc
    echo "complete -o default -F __start_kubectl k" >> /home/ubuntu/.bashrc
    echo "complete -o default -F __start_kubectl k" >> /root/.bashrc

}

function get_cluster_info () {
    kubectl config view -o jsonpath=\"{.clusters[*].cluster.server}\" > /tmp/cluster_server.out
    cat ~/.kube/config > /tmp/kube_config

    aws s3 cp /tmp/cluster_server.out s3://${s3buckit_name};
    aws s3 cp /tmp/kube_config s3://${s3buckit_name};
}

install_necessery_components
preprare_kubernetes
start_cluster
get_cluster_info

mkdir /home/ubuntu/config
touch /home/ubuntu/config/ready
