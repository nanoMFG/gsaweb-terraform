# Requests a new wildcard SSL/TLS certificate from AWS Certificate Manager (ACM).
resource "aws_acm_certificate" "cert" {
  domain_name    = var.env == "prod" ? var.domain_name : "${var.env}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name        = "${var.name}_${var.env}_certificate"
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}
