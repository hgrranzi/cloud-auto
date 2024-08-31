resource "aws_subnet" "app-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.available_zone
  tags = {
    Name : "${var.prefix}-subnet-1"
  }
}

resource "aws_route_table" "app-route-table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-internet-gateway.id
  }
  tags = {
    Name : "${var.prefix}-route-table"
  }
}

resource "aws_internet_gateway" "app-internet-gateway" {
  vpc_id = var.vpc_id
  tags = {
    Name : "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table_association" "app-route_table_a" {
  route_table_id = aws_route_table.app-route-table.id
  subnet_id      = aws_subnet.app-subnet-1.id
}