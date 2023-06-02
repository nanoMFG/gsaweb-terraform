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
