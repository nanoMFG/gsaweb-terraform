variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "name" {
  description = "Project name"
  type        = string
  default = "gsaweb"
}
variable "env" {
  description = "Project environment such as dev, qa or prod"
  type        = string
}
variable "domain_name" {
  description = "Domain for website"
  type        = string
  default = "127.0.0.1"
}
# Region VPC, subnets and availability zones
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
variable "vpc_cidr" {
default = "178.0.0.0/16"
}
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
variable "instance_type" {
default = "t3-micro"
}
variable "instance_ami" {
  default = "ami-097a2df4ac947655f"
}
variable "route53_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  type        = string
  default     = "dummy"
}