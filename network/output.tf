# Outputs the ID of the web security group. This can be used 
# as input to other resources that need to reference the security group
output "web_sg_id" {
  description = "Web server security group ID"
  value       = aws_security_group.web_sg.id
}
# Security group id for the ALB
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
# Outputs the VPC ID
output "vpc_id" {
  value = aws_vpc.app_vpc.id
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
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}
output "availability_zones_used" {
  description = "List of availability zones used for the public subnets"
  value       = [for s in aws_subnet.public_subnet : s.availability_zone]
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
output "certificate_dvo" {
   value = aws_acm_certificate.cert.domain_validation_options
}
output "certificate_domain_name" {
  value = aws_acm_certificate.cert.domain_name
}
