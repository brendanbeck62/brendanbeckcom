variable "prefix" {
  default     = "brendanbeckcom"
  description = "app name to prefix buckets with"
}

output "ec2_url" {
  value = aws_instance.ubuntu_2004.public_ip
}
