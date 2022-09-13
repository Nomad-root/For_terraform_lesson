data "aws_availability_zones" "zone" {}
resource "aws_vpc" "vpc" {
  cidr_block = var.VPC_CIDR
  tags = {
    name ="${var.env}-vpc"
  }
}
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name ="${var.env}-gateway"
  }
}
#--------------------------------------------------------------------------
resource "aws_subnet" "pub_subnet" {
  count = length(var.pub_subnet)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pub_subnet, count.index)
  availability_zone = data.aws_availability_zones.zone.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    name ="${var.env}-subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    name ="${var.env}-route"
  }
}
resource "aws_route_table_association" "ruote_subnet" {
  count = length(aws_subnet.pub_subnet[*].id)
  route_table_id = aws_route_table.route.id
  subnet_id = element(aws_subnet.pub_subnet[*].id, count.index)
}
#--------------------------------------------------------------------------
resource "aws_eip" "static_ip" {
  count = length(var.private_subnet)
  vpc = true
  tags = {
    name ="${var.env}-static_ip-${count.index + 1}"
  }
}
resource "aws_nat_gateway" "static_gateway" {
  count = length(var.private_subnet)
  allocation_id = aws_eip.static_ip[count.index].id
  subnet_id = element(aws_subnet.pub_subnet[*].id, count.index)
  tags = {
    name ="${var.env}-static_gateway-${count.index + 1}"
  }
}
#--------------------------------------------------------------------------
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnet, count.index)
  availability_zone = data.aws_availability_zones.zone.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    name ="${var.env}-private_subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "private_route" {
  count = length(var.private_subnet)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.static_gateway[count.index].id
  }
  tags = {
    name ="${var.env}-private_route-${count.index + 1}"
  }
}
resource "aws_route_table_association" "private_ruote_subnet" {
  count = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.private_route[count.index].id
  subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
}






















