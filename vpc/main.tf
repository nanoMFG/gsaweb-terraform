resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}_${var.env}_app-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name}_${var.env}_vpc_igw"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}_${var.env}_public_rt"
  }
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
variable "vpc_cidr" {
default = "178.0.0.0/16"
}
output "vpc_id" {
  value = aws_vpc.app_vpc.id
}
