provider "aws" {
  region = "us-east-1"
}
data "aws_ami" "ami_ubu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
output "ami" {
  value = data.aws_ami.ami_ubu.id
}