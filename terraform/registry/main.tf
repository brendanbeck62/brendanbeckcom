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
    key            = "ecr-registry-terraform.tfstate"
    region         = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

# Create the repo
resource "aws_ecr_repository" "main" {
  name = "${var.prefix}-repo"
}# end create repr

variable "prefix" {
  default = "brendanbeckcom"
}

output "ecr_repo" {
  description = "name of ecr repo"
  value = aws_ecr_repository.main.name
}
