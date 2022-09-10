output "ami" {
  value = data.aws_ami.auto_ami.id
}
output "ami_usa_1" {
  value = data.aws_ami.auto_ami_usa_1.id
}
output "ami_usa_2" {
  value = data.aws_ami.auto_ami_usa_2.id
}
output "vpc_1" {
  value = aws_default_vpc.VPC.id
}
output "vpc_2" {
  value = aws_default_vpc.VPC_USA_1.id
}
output "vpc_3" {
  value = aws_default_vpc.VPC_USA_2.id
}