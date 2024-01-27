resource "ssh_resource" "example" {
  host         = var.instance_public_ip_addr
  private_key  = file(var.aws_instance_ssh_key)
  user         = var.username
  #agent        = false

  file {
    content     = file("addons/kubevirt-operator.yaml")
    destination = "/home/ubuntu/kubevirt-operator.yaml"
    permissions = "0700"
  }

  file {
    content     = file("addons/kubevirt-cr.yaml")
    destination = "/home/ubuntu/kubevirt-cr.yaml"
    permissions = "0700"
  }

  timeout = "1m"

  commands = [
    "echo '1'",
  ]
}

output "result" {
  value = try(jsondecode(ssh_resource.example.result), {})
}