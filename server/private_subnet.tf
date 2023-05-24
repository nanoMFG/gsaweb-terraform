resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "${var.name}_${var.env}_private_subnet"
  }
}
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "${var.name}_${var.env}_nat_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.name}_${var.env}_nat"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}_${var.env}_private_rt"
  }
}

resource "aws_route_table_association" "private_rt_asso" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
