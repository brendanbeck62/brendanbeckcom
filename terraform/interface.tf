variable "prefix" {
  default     = "brendanbeckcom"
  description = "app name to prefix buckets with"
}

locals {
  env = {
    default = {
      env_suffix      = ""
      container_count = 1
    }
    prod = {
      env_suffix      = "prod"
      container_count = 1
    }
    test = {
      env_suffix      = "test"
      container_count = 1
    }
  }
  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])

}

output "alb_url" {
  description = "URL of load balancer to hit from the outside world"
  value       = aws_alb.prod.dns_name
}

output "prefix" {
  description = "output prefix so it can be used by child directories"
  value       = var.prefix
}

output "vpc_id" {
  description = "id of the default vpc"
  value       = aws_default_vpc.default_vpc.id
}
output "subnet_a_id" {
  description = "id of subnet a"
  value       = aws_default_subnet.default_subnet_a.id
}
output "subnet_b_id" {
  description = "id of subnet b"
  value       = aws_default_subnet.default_subnet_b.id
}
output "subnet_c_id" {
  description = "id of subnet c"
  value       = aws_default_subnet.default_subnet_c.id
}
output "subnet_d_id" {
  description = "id of subnet d"
  value       = aws_default_subnet.default_subnet_c.id
}
