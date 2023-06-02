# This resource block is responsible for creating public subnets within the specified VPC. 
# The number of subnets created is determined by the length of the 'availability_zones' variable. 
# Each subnet is associated with a unique CIDR block and availability zone.
# For instances launched in these subnets, 'map_public_ip_on_launch' attribute is set to 'true' to enable automatic public IP assignment. 
resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.name}_${var.env}_public-subnet-${count.index}"
  }
}

# This resource block is responsible for associating the created public subnets with a route table. 
# The count, determined by the length of the 'availability_zones' variable, corresponds to the number of subnets. 
# It creates a route table association for each subnet, allowing to define routes for outbound traffic from the subnets.
resource "aws_route_table_association" "public_rt_asso" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = var.public_rt_id
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
variable "public_rt_id" {
  description = "ID of the public route table"
  type        = string
}
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}
# Creates a private subnet within the VPC. This is where your instances and 
# other resources will be located. The subnet's traffic will be routed through 
# the NAT gateway to reach the internet.
resource "aws_subnet" "private_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.name}_${var.env}_private_subnet"
  }
}

# Allocates an Elastic IP address (EIP) for use with the NAT gateway. 
# An EIP is a static, public IPv4 address that you can allocate to your AWS account.
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "${var.name}_${var.env}_nat_eip"
  }
}

# Creates a NAT gateway to allow outbound internet traffic from instances in 
# the private subnet. The NAT gateway is placed in the public subnet and is 
# associated with an Elastic IP address (EIP) to enable internet connectivity.
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.name}_${var.env}_nat"
  }
}

# Creates a route table for the private subnet. This defines how traffic is 
# routed from the subnet to other networks. In this case, all traffic 
# (0.0.0.0/0) is directed to the NAT gateway.
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}_${var.env}_private_rt"
  }
}

# Associates the private subnet with the route table. This ensures that 
# traffic from the subnet is routed according to the rules defined in 
# the route table.
resource "aws_route_table_association" "private_rt_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "178.0.10.0/24"
}
output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

# common vars
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

# Defines a variable to specify the ID of the VPC in which the 
# security group will be created
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
