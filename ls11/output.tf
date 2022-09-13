output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
output "pub_subnet" {
  value = aws_subnet.pub_subnet[*].id
}
output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}