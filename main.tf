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
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  region  = "us-west-2"
}

# ami lookup
data "aws_ami" "ubuntu_2004" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu_2004" {
  # 20.04
  ami           = data.aws_ami.ubuntu_2004.id
  instance_type = "t2.micro"

  tags = {
    Name = "${var.prefix}-test"
  }
}

# TODO: add key pair
# TODO: add ssh and port 443 allows
# TODO: how to actually run the webserver
