resource "aws_lb" "palp" {
  name               = "public-alb"
  internal           = var.state[0]
  load_balancer_type = "application"
  subnets            = var.subnet_ids1
  security_groups    = [var.sg_id]

  tags = {
    Name = "public-alb"
  }
}

resource "aws_lb_target_group" "palp" {
  name     = "proxy-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthcheck"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "palp" {
  load_balancer_arn = aws_lb.palp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.palp.arn
  }
}

resource "aws_lb_target_group_attachment" "ptargets" {
  count            = length(var.target_instance_ids1)
  target_group_arn = aws_lb_target_group.palp.arn
  target_id        = var.target_instance_ids1[count.index]
  port             = 80
}

resource "aws_lb" "pralp" {
  name               = "private-alb"
  internal           = var.state[1]
  load_balancer_type = "application"
  subnets            = var.subnet_ids2
  security_groups    = [var.sg_id]

  tags = {
    Name = "private-alb"
  }
}

resource "aws_lb_target_group" "pralp" {
  name     = "backend-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/healthcheck"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "pralp" {
  load_balancer_arn = aws_lb.pralp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pralp.arn
  }
}

resource "aws_lb_target_group_attachment" "prtargets" {
  count            = length(var.target_instance_ids2)
  target_group_arn = aws_lb_target_group.pralp.arn
  target_id        = var.target_instance_ids2[count.index]
  port             = 80
}
