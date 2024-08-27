provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "cloud_ubuntu" {
  ami           = "ami-04a92520784b93e73"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_security_groups.id]
  user_data = <<EOF
EOF
}

resource "aws_security_group" "my_security_groups" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
