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
variable "region" {
  description = "AWS region"
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