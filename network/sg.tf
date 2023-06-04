# Creates a security group for the web server.
# Security groups act as a virtual firewall for your instance to control inbound and outbound traffic.
resource "aws_security_group" "web_sg" {
  name        = "${var.name}_${var.env}_web_sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.app_vpc.id

  # Defines the inbound (ingress) rules for the security group.
  # Here it's allowing traffic from the Load Balancer security group (elb_sg).
  # The protocol is set to -1, which means all protocols are allowed.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.alb_sg.id]
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

# Creates a security group that allows inbound HTTPS (443) traffic 
# to the load balancer from anywhere. It also allows all outbound 
# traffic from the load balancer to anywhere.
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}_${var.env}_alb_sg"
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
    Name = "${var.name}_${var.env}_alb_sg"
  }
}

