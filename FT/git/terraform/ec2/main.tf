data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    owners = ["099720109477"]
}


resource "aws_instance" "aws_instance" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = var.instance_type
    iam_instance_profile        = var.iam_instance_profile
    subnet_id                   = var.subnet_id
    security_groups             = var.security_group
    key_name                    = var.key_name
    user_data                   = var.user_data

    tags = {
      Name = "${var.srv}-srv"
    }
}