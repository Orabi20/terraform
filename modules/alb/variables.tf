variable "vpc_id" {
  type = string
}
variable "subnet_ids1" {
  type = list(string)
}
variable "subnet_ids2" {
  type = list(string)
}
variable "sg_id" {
  type = string
}

variable "target_instance_ids1" {
  type = list(string)
}
variable "target_instance_ids2" {
  type = list(string)
}
variable "state" {
  type = list(bool)
}
