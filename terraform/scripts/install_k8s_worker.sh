#!/bin/bash

######### ** FOR WORKER NODE ** #########

hostname k8s-worker-${worker_number}
echo "k8s-worker-${worker_number}" > /etc/hostname

export AWS_ACCESS_KEY_ID=${access_key}
export AWS_SECRET_ACCESS_KEY=${private_key}
export AWS_DEFAULT_REGION=${region}

#Installing packages
apt install awscli -y


#next line is getting EC2 instance IP, for kubeadm to initiate cluster
#we need to get EC2 internal IP address- default ENI is eth0
export ipaddr=`ip address|grep eth0|grep inet|awk -F ' ' '{print $2}' |awk -F '/' '{print $1}'`


# the kubeadm init won't work entel remove the containerd config and restart it.
#rm /etc/containerd/config.toml
#systemctl restart containerd

# to insure the join command start when the installion of master node is done.
sleep 90

aws s3 cp s3://${s3buckit_name}/join_command.sh /tmp/.
chmod +x /tmp/join_command.sh
bash /tmp/join_command.sh
