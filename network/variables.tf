# Defines a variable to be used as the name in the resource tags
variable "name" {
  description = "Project name"
  type        = string
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

# Defines a variable for the VPC CIDR block
variable "vpc_cidr" {
  default = "178.0.0.0/16"
}
# priviate subnet cidr block for use the (ec2) instance module
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "178.0.10.0/24"
}
# variable "availability_zones" {
#   description = "List of availability zones to be used"
#   type        = list(string)
#   default     = ["us-east-2c", "us-east-2b"]
# }
variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["178.0.20.0/24", "178.0.30.0/24"]
}
