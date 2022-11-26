variable "prefix" {
  default     = "brendanbeckcom"
  description = "app name to prefix buckets with"
}

output "alb_url" {
  description = "URL of load balancer to hit from the outside world"
  value = aws_alb.prod.dns_name
}
