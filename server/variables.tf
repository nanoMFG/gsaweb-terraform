variable "name" {
  description = "Project name"
  type        = string
  default = "gsaweb"
}
variable "env" {
  description = "Project environment such as dev, staging, production"
  type        = string
}
# DNS
# variable "create_dns_zone" {
#   description = "If true, create new route53 zone, if false read existing route53 zone"
#   type        = bool
#   default     = false
# }
variable "domain_name" {
  description = "Domain for website"
  type        = string
  default = "127.0.0.1"
}
# VPC and Subnets
variable "vpc_cidr" {
default = "178.0.0.0/16"
}
# variable "subnet_zone" {
# default = "us-east-2a"
# }
# variable "public_subnet_cidr" {
#   description = "CIDR block for the public subnet"
#   default = "178.0.10.0/24"
# }
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "178.0.10.0/24"
}
variable "availability_zones" {
  description = "List of availability zones to be used"
  type        = list(string)
  default     = ["us-east-2c", "us-east-2b"]
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["178.0.20.0/24", "178.0.30.0/24"]
}
# variable "aws_instance" {
#   description = "If true, use plain aws_instance (EC2) resources directly."
#   type = bool
#   default = true
# }
# variable "aws_auto_scaler" {
#   description = "IF true, negates aws_instance and deploys auto scaler instead"
#   type = bool
#   default = false
# }
variable "instance_type" {
default = "t3-micro"
}
variable "instance_ami" {
  default = "ami-097a2df4ac947655f"
}
# variable "aws_load_balancer" {
#   default = false
#   type = bool
# }
variable "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  type        = string
  default     = "dummy"
}
# variable "use_existing_route53_zone" {
#   description = "If true, use an existing Route53 zone for the environment, if false, do not use it"
#   type        = bool
#   default     = false
# }
