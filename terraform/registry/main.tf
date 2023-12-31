terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "356960567614-us-west-2-remote-state"
    encrypt        = true
    dynamodb_table = "356960567614-us-west-2-remote-state-lock"
    key            = "bbcom/bbcom-ecr.tfstate"
    region         = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

locals {
  env = {
    default = {
      env_suffix = ""
    }
    prod = {
      env_suffix = "-prod"
    }
    test = {
      env_suffix = "-test"
    }
  }
  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])

}

# Create the repo
resource "aws_ecr_repository" "main" {
  name = "brendanbeckcom-repo${local.workspace["env_suffix"]}"
} # end create repr

output "ecr_repo" {
  description = "name of ecr repo"
  value       = aws_ecr_repository.main.name
}


