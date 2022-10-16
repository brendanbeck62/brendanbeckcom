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
  region = "us-west-2"
}

resource "aws_instance" "ubuntu_2004" {
  #ami                    = data.aws_ami.ubuntu_2004.id
  ami                    = "ami-04d6f7e6d7e933ddb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "aws-ec2-brendanbeckcom"

  tags = {
    Name = "${var.prefix}-test"
  }
}

resource "aws_security_group" "main" {
  name        = "main"
  description = "all all out, ssh http https in"
  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties
    # Good for development
    create_before_destroy = true
  }

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    # TODO: change to port 80
    {
      from_port        = 5000
      to_port          = 5000
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "flask default 5000"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

# TODO: Elastic IP
