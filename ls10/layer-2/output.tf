output "server_sg" {
  value = aws_security_group.server.id
}
output "public_ip" {
  value = aws_instance.webserver.public_ip
}