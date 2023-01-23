# TARGET GROUP

resource "aws_lb_target_group" "main-tg" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main-vpc.id
# TARGET GROUP HEALTH CHECK
     health_check {
      healthy_threshold   = "3"
      interval            = "10"
      unhealthy_threshold = "2"
      timeout             = "10"
      path                = "/"
      port                = "80"
  }
}

# TARGET GROUP ATTACHMENT WITH INSTANCE

resource "aws_lb_target_group_attachment" "main-tg-attachment" {
  target_group_arn = aws_lb_target_group.main-tg.arn
  target_id        = aws_instance.frontend-srv.id
  port             = 80
}

# APPLICATION LOAD BALANCER

resource "aws_lb" "main-alb" {
  name               = "test-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend-srv-sg.id]
  subnets            = [
    aws_subnet.webserver-sn1.id,
    aws_subnet.webserver-sn2.id
  ]

  enable_deletion_protection = true

  tags = {
    Name = "alb"
  }
}

# LISTNER RULE

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-tg.arn
  }
}