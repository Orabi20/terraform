terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-orabi1"
    key            = "labs/reverse-proxy/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-orabi1"
    encrypt        = true
  }
}
