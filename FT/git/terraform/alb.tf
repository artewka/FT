resource "aws_lb" "blue" {
  name               = "blue"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [module.vpc.public_subnet_ids[0],module.vpc.public_subnet_ids[1]]
}

resource "aws_lb" "green" {
  name               = "green"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [module.vpc.public_subnet_ids[0],module.vpc.public_subnet_ids[1]]
}

resource "aws_lb_target_group" "blue_web" {
  name     = "blue-target-group-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id
  health_check {
    path   = "/"
  }
}

resource "aws_lb_target_group" "blue_php" {
  name     = "blue-target-group-php"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id 
  health_check {
    path   = "/phpmyadmin"
  }
}

resource "aws_lb_target_group" "green_web" {
  name     = "green-target-group-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id
  health_check {
    path   = "/"
  }
}

resource "aws_lb_target_group" "green_php" {
  name     = "green-target-group-php"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_cidr_id 
  health_check {
    path   = "/phpmyadmin"
  }
}

resource "aws_lb_target_group_attachment" "web_srv_1" {
  count            = length(module.web[0].aws_instance_id)
  target_group_arn = aws_lb_target_group.blue_web.arn
  target_id        = element(module.web[0].aws_instance_id,count.index)
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_srv_2" {
  count            = length(module.web[1].aws_instance_id)
  target_group_arn = aws_lb_target_group.green_web.arn
  target_id        = element(module.web[1].aws_instance_id,count.index)
  port             = 80
}

resource "aws_lb_target_group_attachment" "phpmyadmin_1" {
  count            = length(module.phpmyadmin[0].aws_instance_id)
  target_group_arn = aws_lb_target_group.blue_php.arn
  target_id        = element(module.phpmyadmin[0].aws_instance_id,count.index)
  port             = 80
}

resource "aws_lb_target_group_attachment" "phpmyadmin_2" {
  count            = length(module.phpmyadmin[1].aws_instance_id)
  target_group_arn = aws_lb_target_group.green_php.arn
  target_id        = element(module.phpmyadmin[1].aws_instance_id,count.index)
  port             = 80
}

# resource "aws_lb_target_group_attachment" "db_server" {
#   count            = length(module.db[0].aws_instance_id)
#   target_group_arn = aws_lb_target_group.starget.arn
#   target_id        = element(module.db[0].aws_instance_id,count.index)
#   port             = 80
# }

resource "aws_lb_listener" "blue_listener_web" {
  load_balancer_arn = aws_lb.blue.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_web.arn
  }
}

resource "aws_lb_listener" "green_listener_web" {
  load_balancer_arn = aws_lb.green.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_web.arn
  }
}

resource "aws_lb_listener" "blue_listener_php" {
  load_balancer_arn = aws_lb.blue.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_php.arn
  }
}

resource "aws_lb_listener" "green_listener_php" {
  load_balancer_arn = aws_lb.green.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_php.arn
  }
}