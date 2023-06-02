# Creates an Application Load Balancer (ALB) which routes incoming HTTP(S) traffic 
# to different target groups based on specified rules.
resource "aws_lb" "web" {
  name                       = "${var.name}-${var.env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
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

# Creates a security group that allows inbound HTTPS (443) traffic 
# to the load balancer from anywhere. It also allows all outbound 
# traffic from the load balancer to anywhere.
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}_${var.env}_alb_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

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
    Name = "${var.name}_${var.env}_alb_sg"
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
output "alb_arn" {
  value = aws_lb.web.arn
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
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