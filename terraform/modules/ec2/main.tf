resource "aws_instance" "web" {
  count         = 3
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(var.subnets, count.index)
  security_groups = [aws_security_group.web_sg.id]

  user_data = templatefile(
    count.index == 0 ? "${path.module}/bootstrap-homepage.sh" :
    count.index == 1 ? "${path.module}/bootstrap-register.sh" :
    "${path.module}/bootstrap-image.sh",
    {}
  )

  tags = {
    Name = "web-instance-${count.index}"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP traffic"
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

resource "aws_lb_target_group_attachment" "homepage" {
  count             = 1
  target_group_arn  = element(var.alb_target_group_arns, 0)
  target_id         = aws_instance.web[0].id
  port              = 80
}

resource "aws_lb_target_group_attachment" "register" {
  count             = 1
  target_group_arn  = element(var.alb_target_group_arns, 1)
  target_id         = aws_instance.web[1].id
  port              = 80
}

resource "aws_lb_target_group_attachment" "image" {
  count             = 1
  target_group_arn  = element(var.alb_target_group_arns, 2)
  target_id         = aws_instance.web[2].id
  port              = 80
}