# Retrieves information about the specified Route 53 hosted zone.
data "aws_route53_zone" "existing_zone" {
  zone_id = var.route53_zone_id
}

# Creates an A record for the website in the Route 53 hosted zone. 
# The record points to the Application Load Balancer's DNS name.
resource "aws_route53_record" "www" {
  name    = var.env == "prod" ? var.domain_name : "${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.web.dns_name
    zone_id                = aws_lb.web.zone_id
    evaluate_target_health = true
  }

  zone_id = data.aws_route53_zone.existing_zone.zone_id  
}

# Requests a new wildcard SSL/TLS certificate from AWS Certificate Manager (ACM).
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name        = "${var.name}_${var.env}_certificate"
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Creates DNS validation records for the SSL/TLS certificate. AWS Certificate Manager 
# uses these records to validate that you own or control the domain for which you're 
# requesting the certificate.
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  records = [each.value.record]
  ttl     = 60
}

# Validates the ACM certificate by checking the DNS validation records.
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
