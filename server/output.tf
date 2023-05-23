output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}
output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.web.id
}
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_elb.webelb.dns_name
}

output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
}
