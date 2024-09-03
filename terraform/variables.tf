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

variable script_path {
  description = "Script to execute after instance creation"
  type        = string
  default     = "scripts/install_docker.sh"
}

variable ssh_private_key {
  type    = string
  default = "id_rsa"
}