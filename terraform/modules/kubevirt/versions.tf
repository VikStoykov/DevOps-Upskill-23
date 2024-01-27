terraform {
  required_version = "1.7.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }
  }
}

provider "ssh" {
  # Configuration options
}