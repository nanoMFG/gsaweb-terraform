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
    target_group_arn = var.alb_target_group_arn
  }
}
variable "certificate_arn" {
  type = string
}
variable "alb_arn" {
  type = string
}
# Attaches the target (application instance) to the target group created above. 
# The ALB will now send incoming traffic to this target.
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = var.alb_target_group_arn
  target_id        = var.target_instance_id
}
variable "alb_target_group_arn" {
  type = string
}
variable "target_instance_id" {
  type = string
}
