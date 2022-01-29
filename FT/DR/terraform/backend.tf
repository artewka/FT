terraform {
  backend "s3" {
    bucket     = "terraform-art-DR"
    key        = "terraform/backend/terraform.tfstate"
    region     = "us-west1"
  }
}
