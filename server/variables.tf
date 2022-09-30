variable "create_dns_zone" {
  description = "If true, create new route53 zone, if false read existing route53 zone"
  type        = bool
  default     = false
}
variable "domain" {
  description = "Domain for website"
  type        = string
}
variable "name" {
  description = "Project name"
  type        = string
}
variable "env" {
  description = "Project environment such as dev, staging, production"
  type        = string
}
