provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = "us-east-2"
  alias = "USA_1"
}
provider "aws" {
  region = "us-west-1"
  alias = "USA_2"
}
resource "aws_default_vpc" "VPC" {}
resource "aws_default_vpc" "VPC_USA_1" {
  provider = aws.USA_1
}
resource "aws_default_vpc" "VPC_USA_2" {
  provider = aws.USA_2
}
resource "aws_security_group" "Linux" {
  vpc_id = aws_default_vpc.VPC.id
  dynamic "ingress" {
    for_each = var.port
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "Linux_for_USA_1" {
  provider = aws.USA_1
  vpc_id = aws_default_vpc.VPC_USA_1.id
  dynamic "ingress" {
    for_each = var.port
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "Linux_for_USA_2" {
  provider = aws.USA_2
  vpc_id = aws_default_vpc.VPC_USA_2.id
  dynamic "ingress" {
    for_each = var.port
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "Server_east_1" {
  ami = data.aws_ami.auto_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.Linux.id]
  tags = {
    Name = "Ubuntu on us-east-1"
    Owner= "Sergey Nomad"
  }
  depends_on = [aws_instance.Server_west_1, aws_instance.Server_east_2]
}
resource "aws_instance" "Server_east_2" {
  provider = aws.USA_1
  ami = data.aws_ami.auto_ami_usa_1.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.Linux_for_USA_1.id]
  tags = {
    Name = "Ubuntu on us-east-2"
    Owner= "Sergey Nomad"
  }
}
resource "aws_instance" "Server_west_1" {
  provider = aws.USA_2
  ami = data.aws_ami.auto_ami_usa_2.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.Linux_for_USA_2.id]
  tags = {
    Name = "Ubuntu on us-west-1"
    Owner= "Sergey Nomad"
  }
  depends_on = [aws_instance.Server_east_2]
}