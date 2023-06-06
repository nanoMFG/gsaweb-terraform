# Retrieves information about the specified Route 53 hosted zone.
data "aws_route53_zone" "existing_zone" {
  zone_id = var.route53_zone_id
}

# Creates an A record for the website in the Route 53 hosted zone. 
# The record points to the Application Load Balancer's DNS name.
resource "aws_route53_record" "www" {
  name    = var.env == "prod" ? var.domain_name : "${var.env}.${var.domain_name}"
  type    = "A"

  # latency_routing_policy {
  #   region = var.region
  # }

  alias {
    name                   = var.alb_web_dns_name
    zone_id                = var.alb_web_zone_id
    evaluate_target_health = true
  }

  zone_id = data.aws_route53_zone.existing_zone.zone_id  
}
