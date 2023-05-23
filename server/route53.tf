data "aws_route53_zone" "existing_zone" {
  zone_id = var.route53_zone_id
}

locals {
  route53_zone_id = var.use_existing_route53_zone ? data.aws_route53_zone.existing_zone.zone_id : ""
}
resource "aws_route53_record" "www" {
  name    = var.env == "production" ? var.domain_name : "${var.env}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.web-elb.dns_name
    zone_id                = aws_elb.example.zone_id
    evaluate_target_health = true
  }

  zone_id = data.aws_route53_zone.existing_zone.zone_id
  
  tags = {
    Name        = "${var.name}_${var.env}_dns_record"
    Environment = var.env
  }
}
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

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
