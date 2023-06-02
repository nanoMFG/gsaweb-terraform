# Requests a new wildcard SSL/TLS certificate from AWS Certificate Manager (ACM).
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.env}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name        = "${var.name}_${var.env}_certificate"
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
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
variable "domain_name" {
  description = "Domain name"
  type        = string
}
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
output "certificate_dvo" {
   value = aws_acm_certificate.cert.domain_validation_options
}
output "certificate_domain_name" {
  value = aws_acm_certificate.cert.domain_name
}