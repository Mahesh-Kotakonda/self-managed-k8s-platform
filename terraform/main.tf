terraform {
  backend "s3" {
    bucket  = "mahesh-k8s-terraform-bucket"
    key     = "self-managed-k8s/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

############################
# AMI
############################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

############################
# VPC
############################
resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "k8s-vpc" }
}

############################
# Internet Gateway
############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s.id
}

############################
# Public Subnets
############################
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-${count.index}"
  }
}

############################
# Private Subnets
############################
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "k8s-private-${count.index}"
  }
}

############################
# NAT Gateway
############################
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

############################
# Route Tables
############################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

############################
# IAM ROLE + INSTANCE PROFILE (NEW)
############################

resource "aws_iam_role" "ec2_ecr_role" {
  name = "k8s-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "k8s-ec2-instance-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

############################
# Security Groups
############################

resource "aws_security_group" "bastion" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.k8s.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nodes" {
  name   = "k8s-nodes-sg"
  vpc_id = aws_vpc.k8s.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Bastion Host
############################
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.bastion_instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "k8s-bastion" }
}

############################
# Control Plane
############################
resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.nodes.id]
  key_name               = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "k8s-control-plane"
    Role = "control-plane"
  }
}

############################
# Worker Nodes
############################
resource "aws_instance" "workers" {
  count                  = 4
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[count.index % 2].id
  vpc_security_group_ids = [aws_security_group.nodes.id]
  key_name               = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}
