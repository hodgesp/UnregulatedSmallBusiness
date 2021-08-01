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
# vpc
###############################################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    },
  )
}

###############################################################################
# Subnets
###############################################################################
resource "aws_subnet" "publicsubneta" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_a
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = "Public Subnet A"
    },
  )
}

resource "aws_subnet" "publicsubnetb" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidr_b
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = "Public Subnet B"
    },
  )
}

resource "aws_subnet" "privatesubneta" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_a
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name = "Private Subnet A"
    },
  )
}

resource "aws_subnet" "privatesubnetb" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_b
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    var.tags,
    {
      Name = "Private Subnet B"
    },
  )
}

###############################################################################
# igw
###############################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "igw-vpc"
    },
  )
}

###############################################################################
# Route Table
###############################################################################
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "Public Route"
    },
  )
}

resource "aws_route_table" "routetableprivatea" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "Private Route A"
    },
  )
}

resource "aws_route_table" "routetableprivateb" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "Private Route B"
    },
  )
}

###############################################################################
# EIP
###############################################################################
resource "aws_eip" "eipnata" {
  vpc = true
}

resource "aws_eip" "eipnatb" {
  vpc = true
}

###############################################################################
# NATGW
###############################################################################
resource "aws_nat_gateway" "natgatewaysubneta" {
  allocation_id = aws_eip.eipnata.id
  subnet_id     = aws_subnet.publicsubneta.id

  tags = merge(
    var.tags,
    {
      Name = "NAT Gateway 1"
    },
  )
}

resource "aws_nat_gateway" "natgatewaysubnetb" {
  allocation_id = aws_eip.eipnatb.id
  subnet_id     = aws_subnet.publicsubnetb.id

  tags = merge(
    var.tags,
    {
      Name = "NAT Gateway 2"
    },
  )
}

###############################################################################
# Route
###############################################################################
resource "aws_route" "routeigw" {
  route_table_id         = aws_route_table.routetablepublic.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "routenatgatewaya" {
  route_table_id         = aws_route_table.routetableprivatea.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgatewaysubneta.id
}

resource "aws_route" "routenatgatewayb" {
  route_table_id         = aws_route_table.routetableprivateb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgatewaysubnetb.id
}

###############################################################################
# Table Association
###############################################################################
resource "aws_route_table_association" "routeassocpublica" {
  subnet_id      = aws_subnet.publicsubneta.id
  route_table_id = aws_route_table.routetablepublic.id
}

resource "aws_route_table_association" "routeassocpublicb" {
  subnet_id      = aws_subnet.publicsubnetb.id
  route_table_id = aws_route_table.routetablepublic.id
}

resource "aws_route_table_association" "routeassocprivatea" {
  subnet_id      = aws_subnet.privatesubneta.id
  route_table_id = aws_route_table.routetableprivatea.id
}

resource "aws_route_table_association" "routeassocprivateb" {
  subnet_id      = aws_subnet.privatesubnetb.id
  route_table_id = aws_route_table.routetableprivateb.id
}

###############################################################################
# Security Groups - ALB
###############################################################################
resource "aws_security_group" "alb_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name_prefix = "alb-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.source_address]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.source_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "alb-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

###############################################################################
# SSL
###############################################################################
resource "tls_private_key" "self" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "self" {
  key_algorithm         = "RSA"
  private_key_pem       = tls_private_key.self.private_key_pem
  validity_period_hours = 2160

  subject {
    common_name         = "self.${var.domain}.com"
    organization        = "${var.domain}-org"
    organizational_unit = "Cloud Architecture"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self" {
  private_key      = tls_private_key.self.private_key_pem
  certificate_body = tls_self_signed_cert.self.cert_pem

  tags = var.tags
}

###############################################################################
# Application Load Balancer
###############################################################################
resource "aws_lb" "alb" {
  load_balancer_type = "application"

  internal        = false
  security_groups = [aws_security_group.alb_security_group.id]
  subnets         = [aws_subnet.publicsubneta.id, aws_subnet.publicsubnetb.id]
}

###############################################################################
# ALB Listeners
###############################################################################
resource "aws_lb_listener" "ALBListenerHTTP" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ALBListenerHTTPS" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.self.arn

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

  vpc_id      = aws_vpc.vpc.id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    port                = 80
    interval            = 15
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 5
    matcher             = 200
    unhealthy_threshold = 3
  }
}

###############################################################################
# Security Groups - EC2
###############################################################################
resource "aws_security_group" "ec2_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name_prefix = "ec2-sg-"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "ec2-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
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

  security_groups = [aws_security_group.ec2_security_group.id]

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
  vpc_zone_identifier  = [aws_subnet.privatesubneta.id, aws_subnet.privatesubnetb.id]

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
# Security Groups - Elasticache
###############################################################################
resource "aws_security_group" "elasticache_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name_prefix = "elasticache-sg-"

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

  tags = merge(
    var.tags,
    {
      Name = "elasticache-sg"
    },
  )

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

  subnet_ids = [aws_subnet.privatesubneta.id, aws_subnet.privatesubnetb.id]
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
  security_group_ids            = [aws_security_group.elasticache_security_group.id]
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
