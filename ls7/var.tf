variable "region" {
  type = string
  description = "Choice your region"
  default = "us-east-1"
}
variable "tags" {
  type = map(any)
  default = {
    Name = "Security group"
    Owner = "Sergey Nomad"
  }
}
variable "instanse_type" {
  type = string
  default = "t2.micro"
}
variable "ports" {
  default = ["80","443"]
}