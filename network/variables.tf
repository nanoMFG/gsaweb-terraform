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

# Defines a variable for the VPC CIDR block
variable "vpc_cidr" {
  default = "178.0.0.0/16"
}
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "178.0.10.0/24"
}