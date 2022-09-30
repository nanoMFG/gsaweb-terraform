variable "aws_region" {
default = "us-west-2"
}
variable "backend_bucket"   { 
    default = "my-terraform-state" 
}
#
variable "website_name" {
default = "gsaweb"
}
variable "website_domain" {
default = "127.0.0.1"
}
variable "website_env" {
default = "testing"
}
#

variable "instance_type" {
default = "t2.micro"
}
variable "profile_name" {
default = "default"
}
variable "instance_key" {
default = "gsakey"
}
variable "vpc_cidr" {
default = "178.0.0.0/16"
}
variable "public_subnet_cidr" {
default = "178.0.10.0/24"
}
