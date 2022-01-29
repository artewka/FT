terraform {
  backend "s3" {
    bucket     = "terraform-art-DR"
    key        = "terraform/backend/terraform.tfstate"
    region     = "eu-west-1"
  }
}
