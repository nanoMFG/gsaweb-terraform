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
    name                   = var.alb_web_dns_name
    zone_id                = var.alb_web_zone_id
    evaluate_target_health = true
  }

  zone_id = data.aws_route53_zone.existing_zone.zone_id  
}

# # Creates DNS validation records for the SSL/TLS certificate. AWS Certificate Manager 
# # uses these records to validate that you own or control the domain for which you're 
# # requesting the certificate.
# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   name    = each.value.name
#   type    = each.value.type
#   zone_id = data.aws_route53_zone.existing_zone.zone_id
#   records = [each.value.record]
#   ttl     = 60
# }

# # Validates the ACM certificate by checking the DNS validation records.
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = var.certificate_arn
#   validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
# }
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
variable "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  type        = string
  default     = "dummy"
}
# variable "certificate_arn" {
#   description = "Certificate ARN"
#   type        = string
# }
variable "alb_web_dns_name" {
  description = "ALB DNS Name"
  type        = string
}
variable "alb_web_zone_id" {
  description = "ALB Zone ID"
  type        = string
}
output "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  value       = data.aws_route53_zone.existing_zone.zone_id
}