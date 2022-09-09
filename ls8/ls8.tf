provider "aws" {
  region = "us-east-1"
}
variable "env" {
  default = "dev"
}
variable "size" {
  default = {
    prod = "t2.micro"
    dev = "t2.nano"
  }
}
variable "port" {
  default = {
    prod = ["80","443"]
    dev = ["80","443","8080","22"]
  }
}
resource "aws_default_vpc" "VPC" {}
resource "aws_instance" "webserver1" {
  count = var.env == "prod" ? 1 : 0
  ami = "ami-052efd3df9dad4825"
  instance_type = lookup(var.size, var.env)
  security_groups = [aws_security_group.For_Linux.id]
}
resource "aws_instance" "webserver2" {
  ami = "ami-052efd3df9dad4825"
  instance_type = lookup(var.size, var.env)
  security_groups = [aws_security_group.For_Linux.id]
}
resource "aws_security_group" "For_Linux" {
  vpc_id = aws_default_vpc.VPC.id
  name        = "Linux_security"
  description = "LS4_security"
  dynamic "ingress" {
    for_each = lookup(var.port, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}