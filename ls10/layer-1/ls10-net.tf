provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "nomad-1"
    key    = "dev/net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "aws_availability_zones" "zone" {}
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  tags = {
    Name = "${var.env}-VPC"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-VPC"
  }
}
resource "aws_subnet" "subnet" {
  count = length(var.subnet)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.subnet, count.index)
  availability_zone = data.aws_availability_zones.zone.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route"
  }
}
resource "aws_route_table_association" "public_route" {
  count = length(aws_subnet.subnet[*].id)
  route_table_id = aws_route_table.route_table.id
  subnet_id = element(aws_subnet.subnet[*].id, count.index)
}