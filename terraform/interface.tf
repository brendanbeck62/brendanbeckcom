variable "prefix" {
  default     = "brendanbeckcom"
  description = "app name to prefix buckets with"
}

output "alb_url" {
  description = "URL of load balancer to hit from the outside world"
  value = aws_alb.prod.dns_name
}

output "prefix" {
  description = "output prefix so it can be used by child directories"
  value = var.prefix
}
