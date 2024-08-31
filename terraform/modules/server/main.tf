resource "aws_security_group" "app-security-group" {
  name   = "app-security-group"
  vpc_id = var.vpc_id

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
  subnet_id         = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app-security-group.id]
  availability_zone = var.available_zone
  associate_public_ip_address = true

  # todo: remove when removing ssh access
  key_name = "mv-key"

  user_data = file(var.script_path)
  user_data_replace_on_change = true

  tags = {
    Name : "${var.prefix}-server"
  }
}