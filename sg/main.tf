# Creates a security group for the web server.
# Security groups act as a virtual firewall for your instance to control inbound and outbound traffic.
resource "aws_security_group" "web_sg" {
  name        = "${var.name}_${var.env}_web_sg"
  description = "Security group for web server"
  vpc_id      = var.vpc_id

  # Defines the inbound (ingress) rules for the security group.
  # Here it's allowing traffic from the Load Balancer security group (elb_sg).
  # The protocol is set to -1, which means all protocols are allowed.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.elb_sg.id]
  }

  # Defines the outbound (egress) rules for the security group.
  # Here it's allowing all traffic to all destinations.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Assigns tags to the security group, which can be useful for organization and tracking costs.
  tags = {
    Name = "${var.name}_${var.env}_web_sg"
  }
}
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

# Defines a variable to specify the ID of the VPC in which the 
# security group will be created
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# Outputs the ID of the web security group. This can be used 
# as input to other resources that need to reference the security group
output "web_sg_id" {
  description = "Web server security group ID"
  value       = aws_security_group.web_sg.id
}

