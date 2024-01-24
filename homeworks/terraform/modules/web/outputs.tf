output "public_ip" {
  value       = aws_instance.amzn.public_ip
  description = "Public IP of the EC2 instance"
}