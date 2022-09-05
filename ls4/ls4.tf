provider "aws" {
  region = "us-east-1"
}
/*
resource "aws_eip" "static_ip" {
  instance = "${aws_instance.AWS_web_server.id}"
  vpc = true
}
*/
resource "aws_instance" "AWS_web_server" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_Linux.id]
  user_data              = templatefile("scriptaws.sh.tpl", {
    f_name = "Sergey"
    l_name = "Nomad"
    names = ["Ivan","Vera","Slava","11111111111"]
  })
  tags = {
    Name = "Amazon Server by Terraform"
    Owner = "Nomad"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_instance" "Ubu" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_Linux.id]
  tags = {
    Name = "Ubuntu Server by Terraform"
    Owner = "Nomad"
  }
  depends_on = [aws_instance.AWS_web_server]
}
resource "aws_security_group" "For_Linux" {
  name        = "Linux_security"
  description = "LS4_security"
  vpc_id = "vpc-2f563b52"
  dynamic "ingress" {
    for_each = ["80","443"]
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
output "ami" {
  value = "${aws_instance.AWS_web_server.ami}"
}
output "vpc" {
  value = "${aws_security_group.For_Linux.vpc_id}"
}
