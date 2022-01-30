data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
      bucket     = var.bucket
      key        = var.key
      region     = var.region
   }
}

resource "cloudflare_record" "console-paas" {
  zone_id         = var.zone
  name            = var.name
  value           = data.terraform_remote_state.remote.outputs.blue_alb_dns
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
}
