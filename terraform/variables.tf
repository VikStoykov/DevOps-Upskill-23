variable "access_key" { #Todo: uncomment the default value and add your access key.
        description = "Access key to AWS console"
        #default = "XXXXXXXXXXXXXX" 
}

variable "secret_key" {  #Todo: uncomment the default value and add your secert key.
        description = "Secret key to AWS console"
        # default = "XXXXXXXXXXXXXXXXXXXXXXXXX" 
}

variable "ami_key_pair_name" { #Todo: uncomment the default value and add your pem key pair name. Hint: don't write '.pem' exction just the key name
        #default = "mykey" 
}

variable "aws_instance_ssh_key" { #Todo: uncomment the default value and add your pem key pair name. Hint: don't write '.pem' exction just the key name
        #default = "mykey" 
}

variable "number_of_worker" {
        description = "number of worker instances to be join on cluster."
        default = 1
}

variable "region" {
        description = "The region zone on AWS"
        default = "eu-west-1" #The zone I selected is us-east-1, if you change it make sure to check if ami_id below is correct.
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-0e3f46af8e849a537" #Ubuntu 20.04
}

variable "instance_type" {
        default = "t2.medium" #the best type to start k8s with it,
}

variable "volume_size" {
        description = "Volume size of instance"
        default = "60" #the best type to start k8s with it,
}
