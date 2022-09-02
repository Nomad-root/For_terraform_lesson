provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "For_UBU" {
  name        = "Dinamic ubuntu security"
  vpc_id = "vpc-2f563b52"
  dynamic "ingress" {
    for_each = ["22","80","443","8080"]
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
  tags = {
    Name = "Dinamic security group"
    Owner = "Sergey Nomad"
  }
}

