module "init" {
  # Start instances in AWS
  source = "./modules/init"

  access_key = var.access_key
  secret_key = var.secret_key
  ami_key_pair_name = var.ami_key_pair_name
}

module "kubevirt" {
  # Apply Kubernetes templates
  source = "./modules/kubevirt"

  instance_public_ip_addr = module.init.instance_master_public_ip
  aws_instance_ssh_key = var.aws_instance_ssh_key
}

# Uncomment and apply with this command:
# sudo terraform apply -target=module.notify

module "notify" {
  # Configure ChatOps
  source = "./modules/notify"

  access_key = var.access_key
  secret_key = var.secret_key
  ami_key_pair_name = var.ami_key_pair_name
}

# Print public IPs of master and nodes
output "instance_master_public_ip" {
  value = module.init.instance_master_public_ip
}

output "instance_workers_public_ip" {
  value = module.init.instance_workers_public_ip
}
