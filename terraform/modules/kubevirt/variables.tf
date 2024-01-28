variable "aws_instance_ssh_key" { #Todo: uncomment the default value and add your pem key pair name. Hint: don't write '.pem' exction just the key name
        #default = "mykey" 
}

variable "instance_public_ip_addr" {
        #default = "ip" 
}

variable "username" { #Todo: uncomment the default value and add your pem key pair name. Hint: don't write '.pem' exction just the key name
        default = "ubuntu" 
}