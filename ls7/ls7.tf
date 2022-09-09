provider "aws" {
  region = var.region
}
#-------------------------------------------------------------------------
# Data
#-------------------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220805.0-x86_64-gp2"]
  }
}
#--------------------------------------------------------------------------
# Resource
#--------------------------------------------------------------------------
resource "aws_default_vpc" "VPCdefault" {}
resource "aws_security_group" "linux_sg" {
  name = "Dynamic security group"
  vpc_id = aws_default_vpc.VPCdefault.id
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Project ="Use vars"})
}
resource "aws_instance" "Amazon_Linux" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instanse_type
  vpc_security_group_ids = [aws_security_group.linux_sg.id]
  tags = var.tags
}
