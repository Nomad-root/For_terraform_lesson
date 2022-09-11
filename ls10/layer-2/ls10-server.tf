provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "nomad-1"
    key    = "dev/server/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "net" {
  backend = "s3"
  config = {
    bucket = "nomad-1"
    key    = "dev/net/terraform.tfstate"
    region = "us-east-1"
  }
}
data "aws_ami" "auto_ami" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
resource "aws_instance" "webserver" {
  ami = data.aws_ami.auto_ami.id
  instance_type = "t2.nano"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id = data.terraform_remote_state.net.outputs.subnet_id[0]
  user_data = file("scriptubu.sh")
  tags = {
    Name = "Web Server"
  }
}
resource "aws_security_group" "server" {
  vpc_id = data.terraform_remote_state.net.outputs.vpc_id
  dynamic "ingress" {
    for_each = var.port
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [data.terraform_remote_state.net.outputs.vpc_cidr]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}