resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "homepage" {
  name     = "homepage-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "register" {
  name     = "register-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "image" {
  name     = "image-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener_rule" "homepage" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.homepage.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_listener_rule" "register" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.register.arn
  }
  condition {
    path_pattern {
      values = ["/register*"]
    }
  }
}

resource "aws_lb_listener_rule" "image" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.image.arn
  }
  condition {
    path_pattern {
      values = ["/image*"]
    }
  }
}

output "target_group_arns" {
  value = [aws_lb_target_group.homepage.arn, aws_lb_target_group.register.arn, aws_lb_target_group.image.arn]
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}