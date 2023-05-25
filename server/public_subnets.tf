# This resource block is responsible for creating public subnets within the specified VPC. 
# The number of subnets created is determined by the length of the 'availability_zones' variable. 
# Each subnet is associated with a unique CIDR block and availability zone.
# For instances launched in these subnets, 'map_public_ip_on_launch' attribute is set to 'true' to enable automatic public IP assignment. 
resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.app_vpc.id
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
  route_table_id = aws_route_table.public_rt.id
}
