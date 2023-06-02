# Creates a new HTTPS listener for the ALB. This is where you define how 
# the load balancer routes requests. When a client sends a request to your 
# load balancer, the listener routes the request to a registered target.
resource "aws_lb_listener" "front_end" {
  # count             = var.env == "dev" ? 0 : 1
  load_balancer_arn = var.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    order            = 100
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
variable "certificate_arn" {
  type = string
}
variable "alb_arn" {
  type = string
}
