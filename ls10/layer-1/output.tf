 output "vpc_id" {
   value = aws_vpc.main.id
 }
 output "vpc_cidr" {
   value = aws_vpc.main.cidr_block
 }
 output "subnet_id" {
   value = aws_subnet.subnet[*].id
 }