# How to build AWS AMI
_This is part of 'Configuration management'_

## Tools
>__EC2__ — Amazon Elastic Compute Cloud is a part of Amazon.com’s cloud-computing platform, Amazon Web Services, that allows users to rent virtual computers on which to run their own computer applications. [Wikipedia]

>__Ansible__ — Ansible is a suite of software tools that enables infrastructure as code. It is open-source and the suite includes software provisioning, configuration management, and application deployment functionality. [Wikipedia]

![Alt text](/images/ansible_aws.png)

## Process Steps
1. Prepare AWS Account
2. Install required software on local computer
3. Setup Non Ansible Local Files — Project Directory, SSH Keys
4. Setup Ansible vault or Hashicorp vault
5. Setup Ansible playbooks
6. Run Ansible to generate EC2 instance
7. Install K8S in instance
8. Create custom AMI from instance

### 1. Prepare AWS Account
If you already have an IAM user with an Access/Secret Access key and EC2 permissions, you can skip this step and proceed to installing the required software on your local computer.

#### Creating an IAM user
To provision EC2 instances, you'll need an AWS account with an IAM user at a minimum. Create one through AWS Console > IAM > Add User, as shown below:
![Alt text](/images/create_iam_user.png)

This is our group:
![Alt text](/images/ami_user_group.png)

and roles to it:
![Alt text](/images/ami_user_group_roles.png)

### 2. Install required software on local computer
Required by AWS Ansible module:
```
# pip3 install boto3
# pip3 install botocore
# ansible-galaxy collection install amazon.aws
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'amazon.aws:7.2.0' to '/home/victor/.ansible/collections/ansible_collections/amazon/aws'
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/amazon-aws-7.2.0.tar.gz to /home/victor/.ansible/tmp/ansible-local-386246rx621fil/tmpm_s0m66v
amazon.aws (7.2.0) was installed successfully
```

### 4. Setup Non Ansible Local Files — Project Directory, SSH Keys
#### Generate SSH keys
Generate SSH keys (to SSH into provisioned EC2 instances) with this command,

1. This creates a public (.pub) and private key in the ~/.ssh/ directory
```# ssh-keygen -t rsa -b 4096 -f ~/.ssh/my_aws```
_Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/victor/.ssh/my_aws
Your public key has been saved in /home/victor/.ssh/my_aws.pub
The key fingerprint is:
SHA256:b7d4bbuVesjW6iBYn9ZCp7p9lyDwp1Y5Hauh/zyO2rU victor@victors-ubuntu
The key's randomart image is:
+---[RSA 4096]----+_

2. Ensure private key is not publicly viewable
```chmod 400 ~/.ssh/my_aws```

### 4. Setup Ansible vault or Hashicorp vault (2 methods)
#### Method 1: Manually enter password
1. Create an ansible vault
```ansible-vault create automation/ansible/group_vars/all/pass.yml```

2. There's a prompt for a password, it's needed for playbook execution/edit
_New Vault password:
Confirm New Vault password:_

With this method, you will be prompted for a password every time playbooks are executed or pass.yml is edited.

#### Method 2: Hashicorp vault
...

### 5. Setup Ansible playbooks
Change configuration to your fits.

### 6. Run Ansible to generate EC2 instance

### 7. Install K8S in instance

### 8. Create custom AMI from instance
