# Creates an Application Load Balancer (ALB) which routes incoming HTTP(S) traffic 
# to different target groups based on specified rules.
resource "aws_lb" "web" {
  name                       = "${var.name}-${var.env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}_${var.env}_alb"
    Environment = var.env
  }
}

# Creates a new target group for the ALB. A target group routes requests 
# to one or more registered targets. In this case, the target is an instance
# running your application.
resource "aws_lb_target_group" "web" {
  name     = "${var.name}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

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

# common vars
# Defines a variable to be used as the name in the resource tags
variable "name" {
  description = "Project name"
  type        = string
  default     = "gsaweb"
}

# Defines a variable to be used as the environment in the resource tags
variable "env" {
  description = "Project environment such as dev, qa or prod"
  type        = string
}
variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}
# Defines a variable to specify the ID of the VPC in which the 
# security group will be created
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}
variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}
output "alb_arn" {
  value = aws_lb.web.arn
}
output "alb_web_dns_name" {
  value = aws_lb.web.dns_name
}
output "alb_web_zone_id" {
  value = aws_lb.web.zone_id
}
output "alb_target_group_arn" {
  value = aws_lb_target_group.web.arn
}