################################
# VPC
################################

resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "k8s-vpc"
  }
}

################################
# Internet Gateway
################################

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "k8s-igw"
  }
}

################################
# Public Subnet
################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.k8s.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s-public-subnet"
  }
}

################################
# Route Table
################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name = "k8s-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

################################
# Security Group
################################

resource "aws_security_group" "k8s" {
  name        = "k8s-sg"
  description = "Security group for Kubernetes cluster"
  vpc_id      = aws_vpc.k8s.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node-to-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}

################################
# Control Plane Instance
################################

resource "aws_instance" "control_plane" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = var.key_name

  tags = {
    Name = "k8s-control-plane"
    Role = "control-plane"
  }
}

################################
# Worker Nodes
################################

resource "aws_instance" "workers" {
  count                  = var.worker_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = var.key_name

  tags = {
    Name = "k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}
