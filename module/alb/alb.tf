##ALB
resource "aws_lb" "alb" {
  name               = "${var.general_config["project"]}-${var.general_config["env"]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.alb_http_sg_id,
    var.alb_https_sg_id
  ]
  subnets         = var.public_subnet_ids
  ip_address_type = "ipv4"

  access_logs {
    bucket  = var.alb_access_log_bucket_id
    prefix  = var.general_config["project"]
    enabled = true
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-alb"
  }
}

##Target Group Blue
resource "aws_lb_target_group" "blue" {
  name             = "${var.general_config["project"]}-${var.general_config["env"]}-tg-blue"
  target_type      = "ip"
  protocol_version = "HTTP1"
  port             = "80"
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-tg-blue"
  }
}

##Target Group Green
resource "aws_lb_target_group" "green" {
  name             = "${var.general_config["project"]}-${var.general_config["env"]}-tg-green"
  target_type      = "ip"
  protocol_version = "HTTP1"
  port             = "80"
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-tg-green"
  }
}


##HTTP Listener
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

##HTTPS Listener
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_alb_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}