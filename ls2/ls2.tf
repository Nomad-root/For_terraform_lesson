provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "UBU_web_server" {
  ami                    = "ami-08d4ac5b634553e16"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_UBU.id]
  user_data              = templatefile("scriptubu.sh.tpl", {
    f_name = "Sergey"
    l_name = "Nomad"
    names = ["Valera","Vitaliy","Petr"]
  })
  tags = {
    Name = "Web Ubuntu Server by Terraform"
    Owner = "Sergey Nomad"
  }
}
resource "aws_instance" "AWS_web_server" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_aws.id]
  user_data              = templatefile("scriptaws.sh.tpl", {
    f_name = "Sergey"
    l_name = "Nomad"
    names = ["Ivan","Vera","Slava"]
  })
  tags = {
    Name = "Web Amazon Server by Terraform"
    Owner = "Sergey Nomad"
  }
}

resource "aws_security_group" "For_UBU" {
  name        = "ubu_security"
  description = "LS1_ubu_security"
vpc_id = "vpc-2f563b52"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "For_aws" {
  name        = "aws_security"
  description = "LS1_aws_security"
  vpc_id = "vpc-2f563b52"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
