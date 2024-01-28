data "aws_ami" "aws_ami" {
  # Owners of AMIs
  owners      = ["amazon", "self"]
  most_recent = true

  # Filter what we want to match from AMIs
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

module "webserver" {
  # What module to use
  source = "./modules/web"

  instance_type = var.instance_type
  # Get datasource ID
  ami_id        = data.aws_ami.aws_ami.id
}

# Print something
output "public_ip" {
  value = module.webserver.public_ip
}