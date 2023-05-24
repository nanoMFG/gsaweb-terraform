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

resource "aws_route_table_association" "public_rt_asso" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

