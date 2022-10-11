variable "create_dns_zone" {
  description = "If true, create new route53 zone, if false read existing route53 zone"
  type        = bool
  default     = false
}
variable "domain" {
  description = "Domain for website"
  type        = string
  default = "127.0.0.1"
}
variable "name" {
  description = "Project name"
  type        = string
  default = "gsaweb"
}
variable "env" {
  description = "Project environment such as dev, staging, production"
  type        = string
}
variable "vpc_cidr" {
default = "178.0.0.0/16"
}
variable "public_subnet_cidr" {
default = "178.0.10.0/24"
}
