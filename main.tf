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
  ami                    = data.aws_ami.ubuntu_2004.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]

  key_name = "aws-ec2-brendanbeckcom"
  #provisioner "remote-exec" {
  #  inline = [
  #    "touch hello.txt",
  #    "echo helloworld remote provisioner >> hello.txt",
  #  ]
  #}
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/brendan/.ssh/aws-ec2-brendanbeckcom.pem")
    timeout     = "4m"
  }

  tags = {
    Name = "${var.prefix}-test"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

# TODO: add port 443 allows
# TODO: how to actually run the webserver
