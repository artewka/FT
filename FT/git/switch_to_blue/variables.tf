#API key for Cloudflare
variable "api_key" {
}

#S3 ucket name for remote state
variable "bucket" {
  default = "terraform-art"
}

#Path for tfstate
variable "key" {
  default = "terraform/backend/terraform.tfstate"
}

#Region for bucket
variable "region" {
  default = "eu-central-1"
}

#Zone id for domain
variable "zone" {
  default = "b1dd1fcec37ef9ccee3de24f8462ebb4"
}

#Domain name
variable "name" {
  default = "artewka.xyz"
}


