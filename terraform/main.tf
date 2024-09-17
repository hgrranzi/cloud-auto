provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.prefix}-vpc"
  }
}

module "app-subnet" {
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.app-vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  available_zone    = var.available_zone
  prefix            = var.prefix
}

module "app-server" {
  source                   = "./modules/server"
  vpc_id                   = aws_vpc.app-vpc.id
  admin_access_cidr_blocks = var.admin_access_cidr_blocks
  aws_ami_id               = var.aws_ami_id
  instance_type            = var.instance_type
  instance_count           = var.instance_count
  available_zone           = var.available_zone
  subnet_id                = module.app-subnet.subnet.id
  prefix                   = var.prefix
  ssh_key_name             = var.ssh_key_name
  ssh_key_path             = var.ssh_key_path
}