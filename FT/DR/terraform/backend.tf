terraform {
  backend "s3" {
    bucket     = "terraform-art-dr"
    key        = "terraform/backend/terraform.tfstate"
    region     = "eu-west-1"
  }
}
