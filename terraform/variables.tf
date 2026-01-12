variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "instance_type" {
  default = "c7i-flex.large"
}

variable "bastion_instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "k8s_key_pair"
}

variable "admin_cidr_blocks" {
  description = "Allowed SSH sources for bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

