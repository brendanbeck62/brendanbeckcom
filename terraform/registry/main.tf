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

# Read the state file from the root to get the prefix variable
data "terraform_remote_state" "root_state" {
  backend = "s3"

  config = {
    bucket         = "brendanbeckcom-remote-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}

# Create the repo
resource "aws_ecr_repository" "main" {
  name = "${data.terraform_remote_state.root_state.outputs.prefix}-repo"
}# end create repr

output "ecr_repo" {
  description = "name of ecr repo"
  value = aws_ecr_repository.main.name
}


