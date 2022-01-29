#security group for web-srv
resource "aws_security_group" "web_srv" {
  name        = "${var.environment}-rules to open ports for web_srv"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id

  dynamic "ingress" {
    for_each = ["22","80"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.public_cidr_block[0],var.public_cidr_block[1]]
  }
}  
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  
  tags = {
    Name = "allow http,https"
  }
}

#security group for db-srv
resource "aws_security_group" "db_srv" {
  name        = "${var.environment}-allow_ssh,mysql"
  description = "Allow ssh,mysql inbound traffic"
  vpc_id      = aws_vpc.Vpc_Ter.id


dynamic "ingress" {
    for_each = ["80","3306","22"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [var.private_cidr_block[0],var.private_cidr_block[1]]
    }
}

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow mysql,http"
  }
}
