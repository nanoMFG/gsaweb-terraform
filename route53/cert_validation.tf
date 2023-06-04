# Creates DNS validation records for the SSL/TLS certificate. AWS Certificate Manager 
# uses these records to validate that you own or control the domain for which you're 
# requesting the certificate.
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in var.certificate_dvo : dvo.domain_name => {
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
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
