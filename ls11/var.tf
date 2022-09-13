variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}
variable "env" {
  default = "prod"
}
variable "pub_subnet" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_subnet" {
  default = ["10.0.11.0/24","10.0.22.0/24"]
}
variable "tags" {
  default = {
    Owner   = "Sergey Nomad"
    Project = "Lesson Module"
  }
}