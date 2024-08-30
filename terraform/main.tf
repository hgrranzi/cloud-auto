provider "aws" {
  region = "eu-west-3"
}

variable vpc_cidr_block {
  type    = string
  default = "10.0.0.0/16"
}

variable subnet_cidr_block {
  type    = string
  default = "10.0.0.0/24"
}

variable available_zone {
  type    = string
  default = "eu-west-3a"
}

variable prefix {
  description = "Prefix for naming resources"
  type        = string
  default     = "dev"
}

variable admin_access_cidr_blocks {
  type = list(string)
  default = []
}

variable aws_ami_id {
  type = string
}

variable instance_type {
  type    = string
  default = "t2.micro"
}

resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "app-subnet-1" {
  vpc_id            = aws_vpc.app-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.available_zone
  tags = {
    Name : "${var.prefix}-subnet-1"
  }
}

resource "aws_route_table" "app-route-table" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-internet-gateway.id
  }
  tags = {
    Name : "${var.prefix}-route-table"
  }
}

resource "aws_internet_gateway" "app-internet-gateway" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name : "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table_association" "app-route_table_a" {
  route_table_id = aws_route_table.app-route-table.id
  subnet_id      = aws_subnet.app-subnet-1.id
}

resource "aws_security_group" "app-security-group" {
  name   = "app-security-group"
  vpc_id = aws_vpc.app-vpc.id

  # todo: no need ssh access at all probably
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_access_cidr_blocks
  }

  ingress {
    description = "PHPMyAdmin access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.admin_access_cidr_blocks
  }

  ingress {
    description = "HTTP WordPress access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS WordPress access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name : "${var.prefix}-security-group"
  }
}

resource "aws_instance" "app-server" {
  ami               = var.aws_ami_id
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.app-subnet-1.id
  vpc_security_group_ids = [aws_security_group.app-security-group.id]
  availability_zone = var.available_zone
  associate_public_ip_address = true

  # todo: remove when removing ssh access
  key_name = "mv-key"

  user_data = file("install_docker.sh")
  user_data_replace_on_change = true

  tags = {
    Name : "${var.prefix}-server"
  }
}