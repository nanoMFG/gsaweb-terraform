# Outputs the ID of the web security group. This can be used 
# as input to other resources that need to reference the security group
output "web_sg_id" {
  description = "Web server security group ID"
  value       = aws_security_group.web_sg.id
}
# Outputs the VPC ID
output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

# Outputs the public route table ID
output "public_rt_id" {
  value = aws_route_table.public_rt.id
}

# Outputs from subnets.tf:
# Outputs the private route table ID
# 
output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}
output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = aws_nat_gateway.nat.id
}
