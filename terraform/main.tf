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

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "dev"
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