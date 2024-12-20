provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
#****** VPC Start ******#

resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "K8S VPC"
  }
}

resource "random_shuffle" "az" {
  input        = ["${var.region}a", "${var.region}b", "${var.region}c"]
  result_count = 1
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = random_shuffle.az.result[0]

  tags = {
    Name = "K8S Subnet"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "K8S Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "k8s_sg" {
  name   = "K8S Ports"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9099
    to_port     = 9099
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#****** VPC END ******#

resource "random_string" "s3name" {
  length = 9
  special = false
  upper = false
  lower = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3buckit.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3buckit.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket" "s3buckit" {
  bucket = "k8s-${random_string.s3name.result}"
  force_destroy = true
 depends_on = [
    random_string.s3name
  ]
}


resource "aws_key_pair" "app_keypair" {
  public_key = file(var.ami_key_pair_name)
  key_name   = "pub_aws_instance_key"
}

resource "aws_instance" "ec2_instance_msr" {
    ami = var.ami_id
    subnet_id = aws_subnet.some_public_subnet.id
    instance_type = var.instance_type
    key_name = aws_key_pair.app_keypair.key_name
    associate_public_ip_address = true
    security_groups = [ aws_security_group.k8s_sg.id ]
    root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
    delete_on_termination = true
    }
    tags = {
        Name = "k8s_master_1"
    }
    user_data_base64 = base64encode("${templatefile("scripts/install_k8s_master.sh", {

    access_key = var.access_key
    private_key = var.secret_key
    region = var.region
    s3buckit_name = "k8s-${random_string.s3name.result}"
    runc_version = var.runc_version
    containerd_version = var.containerd_version
    kubernetes_version = var.kubernetes_version
    virtctl_version = var.virtctl_version
    calico_version = var.calico_version
    })}")

    depends_on = [
    aws_s3_bucket.s3buckit,
    random_string.s3name
  ]

    
}

# Create a CloudWatch alarm to trigger an alert when a CPU utilization 
# for a specific VM is higher than 50 percent
resource "aws_cloudwatch_metric_alarm" "high_cpu_master" {
  alarm_name  = "EC2 High CPU (${aws_instance.ec2_instance_msr.id})"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  # You have to create a separate alarm for each EC2 instance
  dimensions = {
    InstanceId = aws_instance.ec2_instance_msr.id
  }
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors CPU utilization for the following instance: ${aws_instance.ec2_instance_msr.id}. If the CPU usage exceeds 50%, you'll get an alert."
  insufficient_data_actions = []

  ok_actions    = ["arn:aws:sns:eu-west-1:471112863051:alarms"]
  alarm_actions = ["arn:aws:sns:eu-west-1:471112863051:alarms"]
}

resource "aws_instance" "ec2_instance_wrk" {
    ami = var.ami_id
    count = var.number_of_worker
    subnet_id = aws_subnet.some_public_subnet.id
    instance_type = var.instance_type
    key_name = aws_key_pair.app_keypair.key_name
    associate_public_ip_address = true
    security_groups = [ aws_security_group.k8s_sg.id ]
    root_block_device {
    volume_type = "gp2"
    volume_size = var.volume_size
    delete_on_termination = true
    }
    tags = {
        Name = "k8s_worker_${count.index + 1}"
    }
    user_data_base64 = base64encode("${templatefile("scripts/install_k8s_worker.sh", {

    access_key = var.access_key
    private_key = var.secret_key
    region = var.region
    s3buckit_name = "k8s-${random_string.s3name.result}"
    worker_number = "${count.index + 1}"

    })}")
  
    depends_on = [
      aws_s3_bucket.s3buckit,
      random_string.s3name,
      aws_instance.ec2_instance_msr
  ]
}

# Create a CloudWatch alarm to trigger an alert when a CPU utilization 
# for a specific VM is higher than 50 percent
resource "aws_cloudwatch_metric_alarm" "high_cpu_worker_zero" {
  alarm_name  = "EC2 High CPU (${aws_instance.ec2_instance_wrk[0].id})"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  # You have to create a separate alarm for each EC2 instance
  dimensions = {
    InstanceId = aws_instance.ec2_instance_wrk[0].id
  }
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors CPU utilization for the following instance: ${aws_instance.ec2_instance_wrk[0].id}. If the CPU usage exceeds 50%, you'll get an alert."
  insufficient_data_actions = []

  ok_actions    = ["arn:aws:sns:eu-west-1:471112863051:alarms"]
  alarm_actions = ["arn:aws:sns:eu-west-1:471112863051:alarms"]
}
