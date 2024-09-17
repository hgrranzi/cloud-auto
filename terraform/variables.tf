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
  default = "ami-04a92520784b93e73"
}

variable instance_type {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  description = " Number of EC2-instances"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 8
    error_message = "Var instance_count should be between 1 and 8."
  }
}

variable ssh_key_name {
  type = string
  default = "id_rsa"
}

variable ssh_key_path {
  type    = string
  default = "id_rsa"
}

variable srcs {
  description = "Path to application's docker compose environment on the host"
  type = string
  default = "/shared/srcs"
}