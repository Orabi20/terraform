variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for proxy instances"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for backend instances"
  type        = list(string)
}



variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to private key file"
  type        = string
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}

variable "proxy_user_data" {
  description = "Path to user data script for proxy"
  type        = string
  default     = "C:/Users/Ahmed Orabi/Desktop/terraform-lab/user_data/proxy.sh"
}

# variable "backend_user_data" {
#   description = "Path to user data script for backend"
#   type        = string
# }
# variable "pralb_dns_name" {
#   type = string
# }
