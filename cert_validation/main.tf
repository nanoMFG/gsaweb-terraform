# Retrieves information about the specified Route 53 hosted zone.
data "aws_route53_zone" "existing_zone" {
  zone_id = var.route53_zone_id
}
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
variable "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  type        = string
  default     = "dummy"
}
variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}
variable "certificate_dvo" {
  description = "Certificate DVO"
   type = list(object({
    domain_name = string
    resource_record_name = string
    resource_record_type = string
    resource_record_value = string
  }))
}
output "certificate_validation_id"  {
  value = aws_acm_certificate_validation.cert_validation.id
}
output "certificate_validation_status"  {
  value = aws_acm_certificate_validation.cert_validation.validation_status
}
output "certificate_arn" {
    var.certificate_arn
}