terraform {
  backend "s3" {
    bucket     = "terraform-art"
    key        = "terraform/backend/terraform.tfstate"
    region     = var.region
  }
}
