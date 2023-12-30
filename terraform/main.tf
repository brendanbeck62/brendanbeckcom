terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "356960567614-us-west-2-remote-state"
    encrypt        = true
    dynamodb_table = "356960567614-us-west-2-remote-state-lock"
    key            = "bbcom/bbcom.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

# Default VPC
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-west-2a"
  tags = {
    Name = "Default Subnet a"
  }
}
resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-west-2b"
  tags = {
    Name = "Default Subnet b"
  }
}
resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-west-2c"
  tags = {
    Name = "Default Subnet c"
  }
}
resource "aws_default_subnet" "default_subnet_d" {
  availability_zone = "us-west-2d"
  tags = {
    Name = "Default Subnet d"
  }
}

# TODO: eventually tag containers dev and prod?
# build and push the container
#aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 356960567614.dkr.ecr.us-west-2.amazonaws.com
#resource "null_resource" "docker_build" {
#  provisioner "local-exec" {
#    command = "docker build -t brendanbeck62/bbcom . --platform=linux/amd64"
#    working_dir = "../src"
#  }
#}
#resource "null_resource" "docker_tag" {
#  provisioner "local-exec" {
#    command = "docker tag brendanbeck62/bbcom:latest 356960567614.dkr.ecr.us-west-2.amazonaws.com/brendanbeckcom-repo:latest"
#    working_dir = "../src"
#  }
#}
#resource "null_resource" "docker_push" {
#  provisioner "local-exec" {
#    command = "docker push 356960567614.dkr.ecr.us-west-2.amazonaws.com/brendanbeckcom-repo:latest"
#    working_dir = "../src"
#  }
#}# end pushing the container

# =============================================================================
# Reference the Repository
data "aws_ecr_repository" "main" {
  name = "${var.prefix}-repo-${local.workspace["env_suffix"]}"
}

# =============================================================================
# Create the cluster
resource "aws_ecs_cluster" "prod" {
  name = "${var.prefix}-cluster-${local.workspace["env_suffix"]}"
}# end create cluster


# =============================================================================
# Create task (run configuration)
resource "aws_ecs_task_definition" "prod" {
  family                   = "${var.prefix}-task-${local.workspace["env_suffix"]}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.prefix}-task-${local.workspace["env_suffix"]}",
      "image": "${data.aws_ecr_repository.main.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.prefix}-ecsTastExecutionRole-${local.workspace["env_suffix"]}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} # end create task



# =============================================================================
# Create the service (like ASG of EC2)
resource "aws_ecs_service" "prod" {
  name            = "${var.prefix}-service-${local.workspace["env_suffix"]}"
  cluster         = "${aws_ecs_cluster.prod.id}"
  task_definition = "${aws_ecs_task_definition.prod.arn}"
  launch_type     = "FARGATE"
  desired_count   = local.workspace["container_count"]

  # attach to the ELB
  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    container_name   = "${aws_ecs_task_definition.prod.family}"
    container_port   = 8080 # Specifying the container port
  }

  network_configuration {
    subnets          = [
      "${aws_default_subnet.default_subnet_a.id}",
      "${aws_default_subnet.default_subnet_b.id}",
      "${aws_default_subnet.default_subnet_c.id}",
      "${aws_default_subnet.default_subnet_d.id}"
    ]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
}
resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}# end create service


# =============================================================================
# Create Load Balancer
resource "aws_alb" "prod" {
  name               = "${var.prefix}-alb-${local.workspace["env_suffix"]}"
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}",
    "${aws_default_subnet.default_subnet_d.id}"
  ]

  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb_target_group" "target_group" {
  name        = "${var.prefix}-targetgroup-${local.workspace["env_suffix"]}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.default_vpc.id}"
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.prod.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }
}# end create loadbalancer

