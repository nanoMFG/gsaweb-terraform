
resource "aws_lb" "web" {
  name               = "${var.name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = aws_subnet.public_subnet.*.id

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}_${var.env}_alb"
    Environment = var.env
  }
}

# Resources to enable cognito login for dev environment

data "aws_caller_identity" "current" {}

resource "aws_cognito_user_pool" "pool" {
  count = var.env == "dev" ? 1 : 0
  name = "${var.name}-${var.env}-user-pool"
  generate_secret = true

  # Add other configurations here
}
resource "aws_cognito_user_pool_client" "client" {
  count = var.env == "dev" ? 1 : 0
  name = "${var.name}-${var.env}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.pool[0].id

  # Add other configurations here
}

resource "aws_cognito_user_pool_domain" "domain" {
  count = var.env == "dev" ? 1 : 0
  domain = "${var.name}-${var.env}-user-pool-domain"
  user_pool_id = aws_cognito_user_pool.pool[0].id
}

resource "aws_lb_listener" "front_end" {
  count             = var.env == "dev" ? 0 : 1
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    order = 100
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  dynamic "default_action" {
    for_each = var.env == "dev" ? [1] : []
    content {
      type = "authenticate-cognito"
      authenticate_cognito {
        user_pool_arn       = aws_cognito_user_pool.pool[0].arn
        user_pool_client_id = aws_cognito_user_pool_client.client[0].id
        user_pool_domain    = aws_cognito_user_pool_domain.domain[0].domain
      }
    }
  }

}

# This resource is created when var.env is "dev"
resource "aws_lb_listener" "front_end_auth" {
  count             = var.env == "dev" ? 1 : 0
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type = "authenticate-cognito"
    authenticate_cognito {
      user_pool_arn       = aws_cognito_user_pool.pool[0].arn
      user_pool_client_id = aws_cognito_user_pool_client.client[0].id
      user_pool_domain    = aws_cognito_user_pool_domain.domain[0].domain
    }
  }

  default_action {
    order            = 100
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.name}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
}

resource "aws_security_group" "elb_sg" {
  name        = "${var.name}_${var.env}_elb_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.name}_${var.env}_elb_sg"
  }
}
