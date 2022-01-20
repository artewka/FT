terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
   region     = "eu-central-1"
}


provider "cloudflare" {
   version = "~> 3.0"
   email = "shadak1997@gmail.com"
   api_key = var.api_key
}
