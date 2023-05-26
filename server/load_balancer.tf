# Creates an Application Load Balancer (ALB) which routes incoming HTTP(S) traffic 
# to different target groups based on specified rules.
resource "aws_lb" "web" {
  name                       = "${var.name}-${var.env}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.elb_sg.id]
  subnets                    = aws_subnet.public_subnet.*.id
  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}_${var.env}_alb"
    Environment = var.env
  }
}

# Fetches the AWS Account ID and ARN of the AWS account associated with 
# the current credentials
data "aws_caller_identity" "current" {}

# Creates a new Amazon Cognito User Pool if the environment is "dev".
# User pools are user directories that provide sign-up and sign-in options 
# for your app users.
resource "aws_cognito_user_pool" "pool" {
  count          = var.env == "dev" ? 1 : 0
  name           = "${var.name}-${var.env}-user-pool"
}

# Creates an Amazon Cognito User Pool Client. User pool apps are clients 
# that have been granted access to call unauthenticated APIs 
# (endpoints that do not have an authenticated user), 
# such as APIs to register, sign in, and handle forgotten passwords.
resource "aws_cognito_user_pool_client" "client" {
  count        = var.env == "dev" ? 1 : 0
  name         = "${var.name}-${var.env}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.pool[0].id
  generate_secret = true
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["openid"]
  callback_urls = ["https://${var.env}.${var.domain_name}"] // Replace with your callback URL

  allowed_oauth_flows_user_pool_client = true
}

# Creates a new Amazon Cognito User Pool Domain.
# This is the domain prefix or custom domain that you use in Amazon Cognito 
# hosted webpages for sign-up and sign-in operations.
resource "aws_cognito_user_pool_domain" "domain" {
  count        = var.env == "dev" ? 1 : 0
  domain       = "${var.name}-${var.env}-user-pool-domain"
  user_pool_id = aws_cognito_user_pool.pool[0].id
}

# Creates a new HTTPS listener for the ALB. This is where you define how 
# the load balancer routes requests. When a client sends a request to your 
# load balancer, the listener routes the request to a registered target.
resource "aws_lb_listener" "front_end" {
  count             = var.env == "dev" ? 0 : 1
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    order            = 100
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Creates a new HTTPS listener with Cognito authentication for the ALB 
# if the environment is "dev". This ensures that only authenticated users 
# can access your application behind the load balancer.
resource "aws_lb_listener" "front_end_auth" {
  count             = var.env == "dev" ? 1 : 0
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    order = 1
    type = "authenticate-cognito"
    authenticate_cognito {
      user_pool_arn       = aws_cognito_user_pool.pool[0].arn
      user_pool_client_id = aws_cognito_user_pool_client.client[0].id
      user_pool_domain    = aws_cognito_user_pool_domain.domain[0].domain
    }
  }

  default_action {
    order            = 2
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Creates a new target group for the ALB. A target group routes requests 
# to one or more registered targets. In this case, the target is an instance
# running your application.
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

# Attaches the target (application instance) to the target group created above. 
# The ALB will now send incoming traffic to this target.
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
}

# Creates a security group that allows inbound HTTPS (443) traffic 
# to the load balancer from anywhere. It also allows all outbound 
# traffic from the load balancer to anywhere.
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
