variable "cidr" {
  default = "10.0.0.0/16"
}
variable "port" {
  default = ["80","443"]
}
variable "env" {
  default = "dev"
}
variable "subnet" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}