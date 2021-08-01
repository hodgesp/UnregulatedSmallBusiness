###############################################################################
# Terraform and Providers blocks
###############################################################################
provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      version = "~> 3.41.0"
    }
  }
}

###############################################################################
# Data Sources and Locals
###############################################################################
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  filter {
    name   = "region-name"
    values = [var.region]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

###############################################################################
# VPC
###############################################################################
resource "aws_default_vpc" "default" {

}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Default subnet for AZ1"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Default subnet for AZ2"
  }
}

###############################################################################
# Security Groups - ALB
###############################################################################
resource "aws_security_group" "all_security_group" {
  vpc_id      = aws_default_vpc.default.id
  name_prefix = "all-sg-"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "all-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

###############################################################################
# Application Load Balancer
###############################################################################
resource "aws_lb" "alb" {
  load_balancer_type = "application"

  internal        = false
  security_groups = [aws_security_group.all_security_group.id]
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}

###############################################################################
# ALB Listeners
###############################################################################
resource "aws_lb_listener" "ALBListenerHTTP" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

}

###############################################################################
# Target Group
###############################################################################
resource "aws_lb_target_group" "target_group" {
  name = var.ec2_name

  vpc_id      = aws_default_vpc.default.id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    interval            = 15
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 5
    matcher             = 200
    unhealthy_threshold = 3
  }
}

###############################################################################
# LC and ASG
###############################################################################
resource "aws_launch_configuration" "lc" {
  name_prefix      = "${var.ec2_name}-"
  image_id         = data.aws_ami.ubuntu.id
  instance_type    = var.instance_type
  user_data_base64 = base64encode(var.user_data)

  security_groups = [aws_security_group.all_security_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = var.ec2_name

  launch_configuration = aws_launch_configuration.lc.name
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  target_group_arns    = [aws_lb_target_group.target_group.arn]
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  tag {
    key                 = "Name"
    value               = var.ec2_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

###############################################################################
# Elasticache
###############################################################################
resource "aws_elasticache_subnet_group" "default" {
  name        = var.elasticache_name
  description = "Subnet Group for the ${var.elasticache_name}"

  subnet_ids = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "${var.elasticache_name}-parameter-group"
  family = "redis6.x"

}

resource "aws_elasticache_replication_group" "default" {
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  availability_zones            = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  engine_version                = "6.x"
  subnet_group_name             = aws_elasticache_subnet_group.default.name
  at_rest_encryption_enabled    = true
  automatic_failover_enabled    = true
  replication_group_id          = "${var.elasticache_name}-group"
  replication_group_description = "${var.elasticache_name} Elasticache"
  port                          = 6379
  parameter_group_name          = aws_elasticache_parameter_group.default.name
  security_group_ids            = [aws_security_group.all_security_group.id]
}

###############################################################################
# S3 Bucket
###############################################################################
resource "random_string" "identifier" {
  length  = 5
  upper   = false
  special = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.bucket_name}-${random_string.identifier.result}"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
