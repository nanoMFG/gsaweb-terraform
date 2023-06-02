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
