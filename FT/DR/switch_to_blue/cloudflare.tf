data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
      bucket     = "terraform-art"
      key        = "terraform/backend/terraform.tfstate"
      region     = "eu-central-1"
   }
}

resource "cloudflare_record" "console-paas" {
  zone_id         = "b1dd1fcec37ef9ccee3de24f8462ebb4"
  name            = "artewka.xyz"
  value           = data.terraform_remote_state.remote.outputs.blue_alb_dns
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}