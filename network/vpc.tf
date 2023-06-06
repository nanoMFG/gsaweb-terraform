# Creates a VPC with the specified CIDR block
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name}_${var.env}_app-vpc"
  }
}

# Creates an internet gateway and attaches it to the created VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name}_${var.env}_vpc_igw"
  }
}

# Creates a route table in the VPC. This defines how traffic is 
# routed from the subnet to other networks. In this case, all traffic 
# (0.0.0.0/0) is directed to the internet gateway.
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

