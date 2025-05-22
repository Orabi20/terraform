terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
# Generate SSH private key
resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Upload public key to AWS as key pair
resource "aws_key_pair" "deployed_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example_key.public_key_openssh
}

# Save the private key to a local file with secure permissions
resource "local_file" "private_key_pem" {
  content         = tls_private_key.example_key.private_key_pem
  filename        = var.private_key_path
  file_permission = "0777"
}




