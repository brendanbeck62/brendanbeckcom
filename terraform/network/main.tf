terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "356960567614-us-west-2-remote-state"
    encrypt        = true
    dynamodb_table = "356960567614-us-west-2-remote-state-lock"
    key            = "bbcom/bbcom-network.tfstate"
    region         = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

#name = "${data.terraform_remote_state.root_state.outputs.prefix}-repo"

# =============================================================================
# Elastic Ip for the load balancer
# TODO: When its time to deploy, import the elastic IP (52.12.167.122) and take over
resource "aws_eip" "load_balancer" {
  vpc = true
}

output "eip_lb_ip" {
  description = "ip of elastic ip for load balancer"
  value = aws_eip.load_balancer.public_ip
}
