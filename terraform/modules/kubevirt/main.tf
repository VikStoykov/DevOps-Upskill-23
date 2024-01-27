resource "ssh_resource" "kubernetes" {
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

  file {
    content     = file("addons/dashboard.yaml")
    destination = "/home/ubuntu/dashboard.yaml"
    permissions = "0700"
  }

  file {
    content     = file("addons/metric_server.yaml")
    destination = "/home/ubuntu/metric_server.yaml"
    permissions = "0700"
  }

  file {
    content     = file("addons/metric_server.yaml")
    destination = "/home/ubuntu/metric_server.yaml"
    permissions = "0700"
  }

  file {
    content     = file("scripts/apply_k8s_modules.sh")
    destination = "/home/ubuntu/apply_k8s_modules.sh"
    permissions = "0700"
  }

  timeout = "1m"

  commands = [
    "/usr/bin/bash /home/ubuntu/apply_k8s_modules.sh &",
  ]
}

output "result" {
  value = try(jsondecode(ssh_resource.example.result), {})
}