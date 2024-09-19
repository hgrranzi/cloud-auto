resource "aws_security_group" "app-security-group" {
  name   = "app-security-group"
  vpc_id = var.vpc_id

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

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.prefix}-key"
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.private_key.private_key_pem}' > /deploy/ansible/'${var.prefix}-key'.pem
      chmod 400 /deploy/ansible/'${var.prefix}-key'.pem
    EOT
  }
}

resource "aws_instance" "app-server" {
  count                       = var.instance_count
  ami                         = var.aws_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app-security-group.id]
  availability_zone           = var.available_zone
  associate_public_ip_address = true

  key_name = aws_key_pair.key_pair.key_name

  provisioner "local-exec" {
    working_dir = "/deploy/ansible"
    command     = "ansible-playbook -i ${self.public_ip}, -u ubuntu --private-key './${var.prefix}-key.pem' deploy-webapp.yml -e srcs=${var.srcs}"
  }

  tags = {
    Name : "${var.prefix}-server-${count.index + 1}"
  }
}