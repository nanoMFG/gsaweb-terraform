data "aws_route53_zone" "existing_zone" {
  count  = var.use_existing_route53_zone ? 1 : 0
  zone_id = var.route53_zone_id
}

locals {
  route53_zone_id = var.use_existing_route53_zone ? data.aws_route53_zone.existing_zone[0].zone_id : ""
}
