terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "brendanbeckcom-remote-state"
    encrypt        = true
    dynamodb_table = "brendanbeckcom-remote-state-lock"
    key            = "network-terraform.tfstate"
    region         = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

# Read the state file from the root to get the prefix variable
data "terraform_remote_state" "root_state" {
  backend = "s3"

  config = {
    bucket         = "brendanbeckcom-remote-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}


#name = "${data.terraform_remote_state.root_state.outputs.prefix}-repo"

# =============================================================================
# Elastic Ip for the load balancer
resource "aws_eip" "load_balancer" {
  vpc = true
}

output "eip_lb_ip" {
  description = "ip of elastic ip for load balancer"
  value = aws_eip.load_balancer.public_ip
}