provider "aws" {
  region = "us-east-1"
}
#-------------------------------------------------------------------------
# Data
#-------------------------------------------------------------------------
data "aws_availability_zones" "avalible" {}
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
    for_each = ["80","443"]
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
  tags = {
    Name = "Security group"
    Owner = "Sergey Nomad"
  }
}
resource "aws_launch_configuration" "webserver" {
  name_prefix = "Web Server First-1"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.linux_sg.id]
  user_data = file("scriptaws.sh")
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "webserver" {
  name = "AG-${aws_launch_configuration.webserver.name}"
  launch_configuration = aws_launch_configuration.webserver.name
  max_size = 3
  min_size = 3
  min_elb_capacity = 3
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.Subnet_1.id,aws_default_subnet.Subnet_2.id]
  load_balancers = [aws_elb.webserver.name]
  dynamic "tag" {
    for_each = {
      Name = "Web AG"
      Owner = "Sergey Nomad"
      TAGKEY = "Tagvalue"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_elb" "webserver" {
  name = "WebELB"
  availability_zones = [data.aws_availability_zones.avalible.names[0],data.aws_availability_zones.avalible.names[1]]
  security_groups = [aws_security_group.linux_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name ="WebELB"
  }
}
resource "aws_default_subnet" "Subnet_1" {
  availability_zone = data.aws_availability_zones.avalible.names[0]
}
resource "aws_default_subnet" "Subnet_2" {
  availability_zone = data.aws_availability_zones.avalible.names[1]
}
#-------------------------------------------------------------------------------------------
# Output
#-------------------------------------------------------------------------------------------
output "Web_loadbalancer_url" {
  value = aws_elb.webserver.dns_name
}