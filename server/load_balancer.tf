#############################################################################
# Inputs(/Deps):
#   - app_vpc.id
#   - aws_subnet.public_subnet.id
#   - aws_security_group.sg.id
# ToDo:
#   - Make subnet and sg defs define lists
#   - Decide if we need multiple subnets
#############################################################################
resource "aws_lb" "load_balancer" {
  count = var.aws_load_balancer ? 1 : 0
  name               = "web-app-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id]
  security_groups    = [aws_security_group.sg.id]
}

resource "aws_lb_listener" "http_listner" {
  count = var.aws_load_balancer ? 1 : 0
  load_balancer_arn = aws_lb.load_balancer[0].arn
  port = 80
  protocol = "HTTP"
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "instances" {
  count = var.aws_load_balancer ? 1 : 0
  name     = "${var.name}_${var.env}_target_group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "instances" {
  count = var.aws_load_balancer ? 1 : 0
  listener_arn = aws_lb_listener.http_listner[0].arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances[0].arn
  }
}
