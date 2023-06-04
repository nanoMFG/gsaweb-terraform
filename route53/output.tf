# For dependency purposes, we export the certificate ARN.
output "certificate_arn" {
  value = var.certificate_arn
}
output "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  value       = data.aws_route53_zone.existing_zone.zone_id
}