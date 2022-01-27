terraform {
  backend "s3" {
    bucket     = "terraform-art"
    key        = "terraform/backend/terraform.tfstate"
    region     = "eu-central-1"
  }
}