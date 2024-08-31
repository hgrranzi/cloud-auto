provider "aws" {
  region = "eu-west-3"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "app-vpc"
  cidr   = var.vpc_cidr_block
  azs = [var.available_zone]
  public_subnets = [var.subnet_cidr_block]
  public_subnet_tags = { Name = "${var.prefix}-subnet-1" }
  tags = {
    Name = "${var.prefix}-vpc"
  }

}

module "app-server" {
  source                   = "./modules/server"
  vpc_id                   = module.vpc.vpc_id
  admin_access_cidr_blocks = var.admin_access_cidr_blocks
  aws_ami_id               = var.aws_ami_id
  instance_type            = var.instance_type
  available_zone           = var.available_zone
  subnet_id                = module.vpc.public_subnets[0]
  prefix                   = var.prefix
  script_path              = var.script_path
}